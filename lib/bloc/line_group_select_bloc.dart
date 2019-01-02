import 'dart:async';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:botchan_client/main.dart';
import 'package:botchan_client/model/line_group_model.dart';
import 'package:botchan_client/network/response/line_group_list_response.dart';
import 'package:rxdart/rxdart.dart';

class LineGroupSelectBloc extends Bloc {
  List<LineGroupModel> _groupList = List();
  List<String> _selectedIds = List();

  // output entry point
  // StreamControllerだとlistenする前に受け取ったアイテムはbufferしないので、
  // BehaviorSubjectで代わりにBufferしてあげる
  final BehaviorSubject<List<LineGroupModel>> _behaviorSubject = BehaviorSubject<List<LineGroupModel>>();
  Stream<List<LineGroupModel>> get groupList => _behaviorSubject.stream.asBroadcastStream();

  LineGroupSelectBloc({List<String> initialSelectedIds}) {
    _selectedIds = initialSelectedIds;
  }

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

  bool isSelected(String groupId) {
    return _selectedIds.contains(groupId);
  }

  void selectOrUnselect(String tappedId) {
    if (_selectedIds.contains(tappedId)) {
      _selectedIds.remove(tappedId);
    } else {
      _selectedIds.add(tappedId);
    }
  }

  List<LineGroupModel> getSelectedGroups() {
    return _groupList.where((model) {
      return isSelected(model.lineGroupId);
    }).toList();
  }

  @override
  void dispose() async {
    _groupList.clear();
    _selectedIds.clear();
    _behaviorSubject.close();
  }

}
