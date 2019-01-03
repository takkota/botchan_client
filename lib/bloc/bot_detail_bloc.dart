import 'dart:async';
import 'dart:isolate';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:botchan_client/main.dart';
import 'package:botchan_client/model/bot_detail_model.dart';
import 'package:botchan_client/model/line_group_model.dart';
import 'package:botchan_client/model/message_edit_model.dart';
import 'package:botchan_client/model/partial/message/image_message.dart';
import 'package:botchan_client/model/partial/push_schedule.dart';
import 'package:botchan_client/model/partial/reply_condition.dart';
import 'package:botchan_client/network/response/bot_detail_response.dart';
import 'package:botchan_client/utility/storage_manager.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

class BotDetailBloc extends Bloc {
  BotDetailModel _data;
  ReceivePort receivePort = new ReceivePort();

  // input entry point
  final StreamController<BotDetailModel> _streamController = StreamController();

  // output entry point
  // StreamControllerだとlistenする前に受け取ったアイテムはbufferしないので、
  // BehaviorSubjectで代わりにBufferしてあげる
  final BehaviorSubject<BotDetailModel> _behaviorSubject = BehaviorSubject<BotDetailModel>();
  Stream<BotDetailModel> get stream => _behaviorSubject.stream;

  BotDetailBloc() {
    _data = BotDetailModel();

    _streamController.stream.listen((bot) {
      _behaviorSubject.sink.add(bot);
    });
  }

  void fetchBotDetail(int botId) async {
    Response res = await dio.post("/bot/detail", data: {"userId": await userId, "botId": botId});
    final data = BotDetailResponse.fromJson(res.data).bot;
    if (res != null) {
      addBot(data);
    }
  }

  void addBot(BotDetailModel bot) {
    _data = bot;
    _streamController.sink.add(_data);
  }

  void changeTitle(String title) {
    _data.title = title;
  }
  void changeType(BotType type) {
    _data.botType = type;
    _streamController.sink.add(_data);
  }
  void changeKeyword(String keyword) {
    _data.replyCondition = _data.replyCondition
      ..keyword = keyword;
  }
  void changeMatchMethod(MatchMethod matchMethod) {
    _data.replyCondition = _data.replyCondition
      ..matchMethod = matchMethod;
    _streamController.sink.add(_data);
  }
  void changeScheduleDateTime(DateTime dateTime) {
    _data.pushSchedule = _data.pushSchedule
      ..scheduleTime = dateTime;
    _streamController.sink.add(_data);
  }
  void changeDays(List<DAY> days) {
    _data.pushSchedule = _data.pushSchedule
      ..days = days;
    _streamController.sink.add(_data);
  }
  void changeAttachedGroups(List<LineGroupModel> attachedGroups) {
    _data.lineGroups = attachedGroups;
    _streamController.sink.add(_data);
  }

  void reflectMessageEdit(MessageEditModel model) {
    _data.message = model.message;
    _streamController.sink.add(_data);
  }

  Future<Tuple2<String, String>> uploadImage() async {
    final file = (_data.message as ImageMessage).cachedImage;

    print("uploading...");
    return StorageManager.uploadImage(file);
  }

  Future<Null> save() async {
    if (_data.message is ImageMessage) {
      print("test:image");
      // 画像メッセージの場合
      if ((_data.message as ImageMessage).cachedImage != null) {
        print("test:upload");
        // 画像を新規 or 更新の時だけuploadする。
        final urls = await uploadImage();
        (_data.message as ImageMessage).originalContentUrl = urls.item1;
        (_data.message as ImageMessage).previewImageUrl = urls.item2;
      }
    }

    final data = {};
    // 共通項目
    data.addAll({
      "message": _data.message.toJson(),
      "title": _data.title,
      "lineGroupIds": _data.lineGroups.map ((group) { return group.lineGroupId; }).toList()
    });
    if (_data.botId != null) {
      // 更新の場合のみ
      data["botId"] = _data.botId;
    }
    if (_data.botType == BotType.REPLY) {
      // 返答タイプ
      data.addAll({
        "userId": await userId,
        "replyConditionId": _data.replyCondition.id,
        "keyword": _data.replyCondition.keyword,
        "matchMethod": _data.replyCondition.matchMethod == MatchMethod.PARTIAL ? "partial" : "exact",
      });
      await dio.post("/bot/reply/save", data: data);
    } else {
      // 通知タイプ
      data.addAll({
        "userId": await userId,
        "pushScheduleId": _data.pushSchedule.id,
        "scheduleTime": DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(_data.pushSchedule.scheduleTime.toLocal()),
        "days": PushSchedule.convertDaysToBitFlag(_data.pushSchedule.days),
      });
      await dio.post("/bot/push/save", data: data);
    }
  }

  BotDetailModel getCurrentModel() {
    return _data;
  }

  dynamic validateForm() {
    if (_data.title.isEmpty) {
      return "タイトルは必ず入力してください。";
    }
    if (_data.botType == BotType.REPLY) {
      if (_data.replyCondition.keyword.isEmpty) {
        return "キーワードは必ず入力してください。";
      }
    } else {
      if (_data.pushSchedule.scheduleTime.isBefore(DateTime.now())) {
        return "通知日時は未来日付を選択してください。";
      }
    }
    if (_data.message == null || !_data.message.hasContent()) {
      return "メッセージが作成されていません。";
    }
    return true;
  }
  @override
  void dispose() async {
    receivePort.close();
    _streamController.close();
    _behaviorSubject.close();
  }
}
