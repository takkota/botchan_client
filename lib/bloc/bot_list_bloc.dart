import 'dart:async';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:botchan_client/main.dart';
import 'package:botchan_client/model/bot.dart';
import 'package:botchan_client/network/response/bot_list_response.dart';
import 'package:rxdart/rxdart.dart';

class BotListBloc extends Bloc {
  List<Bot> _botList = List();

  // input entry point
  final StreamController<List<Bot>> _listStreamController = StreamController();
  final StreamController<Bot> _streamController = StreamController();

  // output entry point
  // StreamControllerだとlistenする前に受け取ったアイテムはbufferしないので、
  // BehaviorSubjectで代わりにBufferしてあげる
  final BehaviorSubject<List<Bot>> _behaviorSubject = BehaviorSubject<List<Bot>>();
  Stream<List<Bot>> get botList => _behaviorSubject.stream;

  BotListBloc() {
    _listStreamController.stream.listen((botList) {
      _botList.addAll(botList);
      _behaviorSubject.sink.add(_botList);
    });
    _streamController.stream.listen((bot) {
      _botList.add(bot);
      _behaviorSubject.sink.add(_botList);
    });
  }

  void fetchBotList() async {
    dio.post("/bot", data: {
      "userId": await userId
    }).then((res) {
      final botList = BotListResponse.fromJson(res.data).botList;
      if (botList.isNotEmpty) {
        addBotAll(botList);
      }
    });
  }

  void addBotAll(List<Bot> botList) {
    _listStreamController.sink.add(botList);
  }
  void addBot(Bot bot) {
    _streamController.sink.add(bot);
  }

  void dispose() async {
    _botList.clear();
    _listStreamController.close();
    _streamController.close();
    _behaviorSubject.close();
  }

}
