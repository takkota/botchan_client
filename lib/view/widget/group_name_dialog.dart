
import 'package:botchan_client/main.dart';
import 'package:flutter/material.dart';

class GroupNameDialog extends StatefulWidget {
  GroupNameDialog({
    Key key,
    this.lineGroupId
  }): super(key: key);

  final int lineGroupId;

  @override
  _GroupNameDialogState createState() => new _GroupNameDialogState();
}

class _GroupNameDialogState extends State<GroupNameDialog> {
  final _groupNameTextEditController = TextEditingController();
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void saveLineGroup() async {
      dio.post("/lineGroup/save",
          data: {"userId": await userId, "lineGroupId": widget.lineGroupId},
      ).then((res) {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop(true);
        }
      })
      .catchError(() {
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text('保存に失敗しました。再度お試しください。')));
      });
    }

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
                    saveLineGroup();
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
}
