import 'dart:async';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:botchan_client/main.dart';
import 'package:botchan_client/model/line_group_model.dart';
import 'package:botchan_client/network/response/bot_list_response.dart';
import 'package:botchan_client/network/response/group_list_response.dart';
import 'package:rxdart/rxdart.dart';

class LineGroupListBloc extends Bloc {
  List<LineGroupModel> _groupList = List();

  // input entry point
  final StreamController<List<LineGroupModel>> _listStreamController = StreamController();

  // output entry point
  // StreamControllerだとlistenする前に受け取ったアイテムはbufferしないので、
  // BehaviorSubjectで代わりにBufferしてあげる
  final BehaviorSubject<List<LineGroupModel>> _behaviorSubject = BehaviorSubject<List<LineGroupModel>>();
  Stream<List<LineGroupModel>> get groupList => _behaviorSubject.stream;

  LineGroupListBloc() {
    _listStreamController.stream.listen((botList) {
      _groupList.addAll(botList);
      _behaviorSubject.sink.add(_groupList);
    });
  }

  void fetchGroupList() async {
    dio.post("/user/group", data: {
      "userId": await userId
    }).then((res) {
      final lineGroupList = LineGroupListResponse.fromJson(res.data).lineGroupList;
      if (lineGroupList.isNotEmpty) {
        addGroupAll(lineGroupList);
      }
    });
  }

  void addGroupAll(List<LineGroupModel> botList) {
    _listStreamController.sink.add(botList);
  }

  void dispose() async {
    _groupList.clear();
    _listStreamController.close();
    _behaviorSubject.close();
  }

}
