import 'package:bloc_provider/bloc_provider.dart';
import 'package:botchan_client/bloc/message_edit_bloc.dart';
import 'package:botchan_client/model/message_edit_model.dart';
import 'package:botchan_client/model/partial/message.dart';
import 'package:botchan_client/model/partial/message/text_message.dart';
import 'package:botchan_client/view/widget/message_editable.dart';
import 'package:botchan_client/view/widget/select_message_type_overlay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageEditor extends StatefulWidget {
  MessageEditor({Key key, this.onCompleteEdit}) : super(key: key);

  final ValueChanged<MessageEditModel> onCompleteEdit;

  @override
  _MessageEditorState createState() => _MessageEditorState();
}

class _MessageEditorState extends State<MessageEditor>{
  MessageEditBloc bloc;
  bool isEditingText = false;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<MessageEditBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("メッセージ編集"),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  widget.onCompleteEdit(bloc.getCurrentModel());
                  Navigator.pop(context);
                },
                textColor: Colors.white,
                child: Text(
                    "完了",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
                )
            )
          ],
        ),
        body: _body(),
    );
  }

  Widget _body() {
    void showAlertOrNot(MessageType type) {
      bloc.messageEditStream.first.then((model) {
        if (model.message.hasContent()) {
          showAlertDialog(() {
            bloc.changeMessageType(type);
          });
        } else {
          bloc.changeMessageType(type);
        }
      });
    }
    return
      Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MessageEditable(onChangedTextFocus: (isEditingText) {
                setState(() {
                  this.isEditingText = isEditingText;
                });
              }),
              Container(
                child: InkWell(
                  child: Icon(Icons.view_quilt),
                  onTap: () {
                    Navigator.of(context).push(
                        MessageTypeSelectOverlay(onSelectType: (type) {
                          showAlertOrNot(type);
                        })
                    );
                    //showAlertOrNot(MessageType.FLEX);
                  },
                ),
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.deepOrangeAccent),
              ),
              Text("レイアウトを変更", style: TextStyle(fontSize: 12.0))
            ],
          ),
          // テキスト編集時の完了ボタン
          Container(
            alignment: FractionalOffset(0.5, 1.0),
            child: _normalToolBar(),
          ),
        ],
      );
  }

  void showAlertDialog(VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text("入力した内容は失われますが、よろしいですか？"),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SimpleDialogOption(
                    child: Text("いいえ"),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                SimpleDialogOption(
                    child: Text("はい"),
                    onPressed: () {
                      onConfirm();
                      Navigator.pop(context);
                    }),
              ],
            )
          ],
        );
      }
    );
  }

  Widget _normalToolBar() {
    if (isEditingText) {
      return Container(
          decoration: BoxDecoration(
              border: BorderDirectional(top: BorderSide(color: Colors.black)),
              color: Colors.grey[200]),
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CupertinoButton(
                child: Text('完了'),
                onPressed: () {
                  FocusScope.of(context).requestFocus(new FocusNode()); // キーボード閉じる
                },
              )
            ],
          ));
    } else {
      return Container();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
