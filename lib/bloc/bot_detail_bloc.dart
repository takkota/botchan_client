import 'dart:async';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:botchan_client/main.dart';
import 'package:botchan_client/model/bot_detail_model.dart';
import 'package:botchan_client/network/request/push_schedule.dart';
import 'package:botchan_client/network/request/reply_condition.dart';
import 'package:botchan_client/network/response/bot_detail_response.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

class BotDetailBloc extends Bloc {
  BotDetailModel _data;

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
    _streamController.sink.add(_data);
  }

  void fetchBotDetail(int botId) async {
    Response res = await dio.post("/bot/detail", data: {"userId": await userId, "botId": botId});
    final botDetail = BotDetailResponse.fromJson(res.data);
    final data = BotDetailModel(
        botId: botDetail.bot.botId,
        title: botDetail.bot.title
    );
    if (res != null) {
      addBot(data);
    }
  }

  Future saveBotDetail() async {
    final data = {};
    if (_data.botId != null) {
      data["botId"] = _data.botId;
    }
    if (_data.botType == BotType.REPLY) {
      data.addAll({
        "userId": await userId,
        "keyword": _data.replyCondition.keyword,
        "matchMethod": _data.replyCondition.matchMethod.toString().toLowerCase(),
        "lineGroupIds": _data.groupIds
      });
      await dio.post("/bot/save/reply", data: data);
    } else {
      data.addAll({
        "userId": await userId,
        "scheduleTime": _data.pushSchedule.scheduleTime.toString(),
        "days": convertDayToBitFlag(_data.pushSchedule.days),
        "lineGroupIds": _data.groupIds
      });
      await dio.post("/bot/save/push", data: data);
    }
  }

  void addBot(BotDetailModel bot) {
    _data = bot;
    _streamController.sink.add(_data);
  }

  void changeTitle(String title) {
    _data.title = title;
    _streamController.sink.add(_data);
  }
  void changeType(BotType type) {
    _data.botType = type;
    _streamController.sink.add(_data);
  }
  void changeKeyword(String keyword) {
    _data.replyCondition = _data.replyCondition
        ..keyword = keyword;
    _streamController.sink.add(_data);
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


  String validateForm() {
    if (_data.botType == BotType.REPLY) {
      if (_data.title.isEmpty) {
        return "タイトルは必ず入力してください。";
      }
    } else {
      if (_data.pushSchedule.scheduleTime.isAfter(DateTime.now())) {
        return "通知日時は未来日付を選択してください";
      }
    }
    return null;
  }
  @override
  void dispose() async {
    _streamController.close();
    _behaviorSubject.close();
  }
}
