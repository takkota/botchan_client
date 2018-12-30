
import 'package:bloc_provider/bloc_provider.dart';
import 'package:botchan_client/bloc/bot_list_bloc.dart';
import 'package:botchan_client/main.dart';
import 'package:botchan_client/model/line_group_model.dart';
import 'package:botchan_client/network/response/line_group_response.dart';
import 'package:flutter/material.dart';

typedef OnSaveSuccess = void Function(LineGroupModel model);
class GroupNameDialog extends StatefulWidget {
  GroupNameDialog({
    Key key,
    this.id,
    this.initialValue = "",
    this.lineGroupId,
    this.onSaveSuccess
  }): super(key: key);

  final OnSaveSuccess onSaveSuccess;
  final int id;
  final String initialValue;
  final String lineGroupId;

  @override
  _GroupNameDialogState createState() => new _GroupNameDialogState();
}

class _GroupNameDialogState extends State<GroupNameDialog> {
  final _groupNameTextEditController = TextEditingController();
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _groupNameTextEditController.text = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        title: Column(
          children: <Widget>[
            Text("追加するグループに名前をつけてください(必須)"),
            TextField(
              decoration: InputDecoration(
                  hintText: 'グループ名を入力してください',
                  errorText: _hasError? 'グループ名が空です' : null
              ),
              controller: _groupNameTextEditController,
            ),
          ],
        ),
        shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(4.0)),
        children: <Widget>[
          Center(
            child: SimpleDialogOption(
                onPressed: () {
                  if (_groupNameTextEditController.text.isNotEmpty) {
                    _saveLineGroup();
                  } else {
                    setState(() {
                      _hasError = _groupNameTextEditController.text.isEmpty;
                    });
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: Text("確定",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0
                      )
                  )),
                  decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                )
            ),
          ),
        ]);
  }

  @override
  void dispose() {
    super.dispose();
    _groupNameTextEditController.dispose();
  }

  void _saveLineGroup() async {
    var data = {};

    data.addAll({
      "userId": await userId,
      "lineGroupId": widget.lineGroupId,
      "displayName": _groupNameTextEditController.text,
    });
    if (widget.id != null) {
      // 更新の時はid必須
      data.addAll({
        "id": widget.id,
      });
    }
    print("save" + data.toString());

    dio.post("/lineGroup/save",
      data: data
    ).then((res) {
      final lineGroup = LineGroupResponse.fromJson(res.data).lineGroupModel;
      widget.onSaveSuccess(lineGroup);
    })
        .catchError(() {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('保存に失敗しました。再度お試しください。')));
    });
  }
}
