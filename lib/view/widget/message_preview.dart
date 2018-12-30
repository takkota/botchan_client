import 'package:bloc_provider/bloc_provider.dart';
import 'package:botchan_client/bloc/bot_detail_bloc.dart';
import 'package:botchan_client/bloc/message_edit_bloc.dart';
import 'package:botchan_client/model/line_group_model.dart';
import 'package:botchan_client/model/message_edit_model.dart';
import 'package:botchan_client/model/partial/message.dart';
import 'package:botchan_client/model/partial/message/image_message.dart';
import 'package:botchan_client/model/partial/message/text_message.dart';
import 'package:flutter/material.dart';

typedef OnSaveSuccess = void Function(LineGroupModel model);
class MessagePreview extends StatefulWidget {
  MessagePreview({
    Key key,
    this.isEditable = false
  }): super(key: key);

  final bool isEditable;

  @override
  _MessagePreviewState createState() => new _MessagePreviewState();
}

class _MessagePreviewState extends State<MessagePreview> {
  MessageEditBloc _bloc;

  @override
  void initState() {
    super.initState();
    print("testd:init");
    _bloc = BlocProvider.of<MessageEditBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    print("testd:build");
    return StreamBuilder(
      stream: _bloc.messageEditStream,
      builder: (BuildContext context, AsyncSnapshot<MessageEditModel> snapshot) {
        if (snapshot.hasData) {
          if (!snapshot.data.message.hasInputAny() && !widget.isEditable) {
            // previewModeでMessage未設定
            return _noMessage();
          }
          return _buildMessageBlocks(snapshot.data.message);
        } else {
          print("testd:container");
          // if (preview)
          return Container();
        }
      },
    );
  }

  Widget _buildMessageBlocks(Message message) {
    print("testd:buildMessage");
    List<Widget> _buildBlocks() {
      List<Widget> blocks = [];
      switch (message.type) {
        case MessageType.TEXT:
          blocks.add(_textBlock(message: message as TextMessage));
          break;
        case MessageType.IMAGE:
          break;
      }
      return blocks;
    }

    return Column(
      children: _buildBlocks()
    );
  }

  Widget _textBlock({TextMessage message}) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30.0))
      ),
      child: Center(
        child: widget.isEditable ? TextFormField(
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '入力してください'
          ),
          onEditingComplete: () {
          },
          initialValue: message.text,
        )
            : Text(message.text),
      ),
    );
  }

  Widget _imageBlock({ImageMessage message}) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30.0))
      ),
      child: Center(
      ),
    );
  }

  Widget _noMessage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.open_in_new),
        Text("メッセージを作成する"),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
  }
