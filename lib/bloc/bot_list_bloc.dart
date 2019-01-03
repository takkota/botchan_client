import 'dart:async';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:botchan_client/main.dart';
import 'package:botchan_client/model/bot_detail_model.dart';
import 'package:botchan_client/network/response/bot_list_response.dart';
import 'package:rxdart/rxdart.dart';

class BotListBloc extends Bloc {
  List<BotDetailModel> _botList = List();

  // input entry point
  final StreamController<List<BotDetailModel>> _listStreamController = StreamController();
  final StreamController<BotDetailModel> _streamController = StreamController();

  // output entry point
  // StreamControllerだとlistenする前に受け取ったアイテムはbufferしないので、
  // BehaviorSubjectで代わりにBufferしてあげる
  final BehaviorSubject<List<BotDetailModel>> _behaviorSubject = BehaviorSubject<List<BotDetailModel>>();
  Stream<List<BotDetailModel>> get botList => _behaviorSubject.stream;

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
      addBotAll(botList);
    });
  }

  void addBotAll(List<BotDetailModel> botList) {
    _listStreamController.sink.add(botList);
  }
  void addBot(BotDetailModel bot) {
    _streamController.sink.add(bot);
  }

  @override
  void dispose() {
    _botList.clear();
    _listStreamController.close();
    _streamController.close();
    _behaviorSubject.close();
  }

}
