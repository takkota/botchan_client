import 'package:bloc_provider/bloc_provider.dart';
import 'package:botchan_client/bloc/message_edit_bloc.dart';
import 'package:botchan_client/model/message_edit_model.dart';
import 'package:botchan_client/model/partial/message.dart';
import 'package:botchan_client/model/partial/message/text_message.dart';
import 'package:botchan_client/view/widget/message_editable.dart';
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
          automaticallyImplyLeading: false,
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  widget.onCompleteEdit(bloc.getCurrentModel());
                  Navigator.pop(context);
                },
                textColor: Colors.white,
                child: Text(
                    "保存",
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
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              InkWell(
                child: Padding(padding: EdgeInsets.all(15.0),child: Icon(Icons.message)),
                onTap: () {
                  showAlertOrNot(MessageType.TEXT);
                },
              ),
              InkWell(
                child: Padding(padding: EdgeInsets.all(15.0),child: Icon(Icons.image)),
                onTap: () {
                  showAlertOrNot(MessageType.IMAGE);
                },
              ),
              InkWell(
                child: Padding(padding: EdgeInsets.all(15.0),child: Icon(Icons.library_books)),
                onTap: () {
                  showAlertOrNot(MessageType.IMAGE);
                },
              ),
            ],
          ),
        ),
        Center(
            child: MessageEditable()
        )
          //child: Text("aaa"),
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

  @override
  void dispose() {
    super.dispose();
  }
}
