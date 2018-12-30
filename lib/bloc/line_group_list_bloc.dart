import 'dart:async';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:botchan_client/main.dart';
import 'package:botchan_client/model/line_group_model.dart';
import 'package:botchan_client/network/response/line_group_list_response.dart';
import 'package:rxdart/rxdart.dart';

class LineGroupListBloc extends Bloc {
  List<LineGroupModel> _groupList = List();

  // output entry point
  // StreamControllerだとlistenする前に受け取ったアイテムはbufferしないので、
  // BehaviorSubjectで代わりにBufferしてあげる
  final BehaviorSubject<List<LineGroupModel>> _behaviorSubject = BehaviorSubject<List<LineGroupModel>>();
  Stream<List<LineGroupModel>> get groupList => _behaviorSubject.stream.asBroadcastStream();

  Future fetchGroupList() async {
    return dio.post("/lineGroup", data: {
      "userId": await userId
    }).then((res) {
      final lineGroupList = LineGroupListResponse.fromJson(res.data).lineGroupList;
      addGroups(lineGroupList);
    });
  }

  void addGroups(List<LineGroupModel> groups) {
    _groupList.addAll(groups);
    _behaviorSubject.sink.add(_groupList);
  }

  void changeGroupDisplayName(int id, String displayName) {
    var index = _groupList.indexWhere((group) {
      return group.id == id;
    });
    final group = _groupList[index];
    _groupList[index] = group..displayName = displayName;

    _behaviorSubject.sink.add(_groupList);
  }

  @override
  void dispose() async {
    _groupList.clear();
    _behaviorSubject.close();
  }

}
