import 'dart:async';

import 'package:botchan_client/model/bot.dart';
import 'package:botchan_client/network/api_client.dart';
import 'package:botchan_client/network/response/bot_list_response.dart';
import 'package:botchan_client/network/response/bot_response.dart';
import 'package:rxdart/rxdart.dart';

class BotDetailBloc {
  BotDetailScreenData _data = BotDetailScreenData(botType: BotType.REPLY);
  // input entry point
  final StreamController<BotDetailScreenData> _streamController = StreamController();

  // output entry point
  // StreamControllerだとlistenする前に受け取ったアイテムはbufferしないので、
  // BehaviorSubjectで代わりにBufferしてあげる
  final BehaviorSubject<BotDetailScreenData> _behaviorSubject = BehaviorSubject<BotDetailScreenData>();
  Stream<BotDetailScreenData> get stream => _behaviorSubject.stream;

  BotDetailBloc() {
    _streamController.stream.listen((bot) {
      _behaviorSubject.sink.add(bot);
    });
    _streamController.sink.add(_data);
  }

  void fetchBotDetail() async {
    final res = await ApiClient(BotDetailResponse.fromJson).post("/bot", {
      "userId": ""
    });
    final botDetail = BotDetailScreenData(
      id: res.bot.id,
      name: res.bot.name
    );
    if (res != null) {
      addBot(botDetail);
    }
  }

  void addBot(BotDetailScreenData bot) {
    _data = bot;
    _streamController.sink.add(_data);
  }

  void changeType(BotType type) {
    _data.botType = type;
    _streamController.sink.add(_data);
  }

  void dispose() async {
    _streamController.close();
    _behaviorSubject.close();
  }
}

class BotDetailScreenData {
  String id;
  String name;
  BotType botType;

  BotDetailScreenData({this.id, this.name, this.botType});
}

enum BotType {
  REPLY, PUSH
}
