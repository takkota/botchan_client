import 'package:bloc_provider/bloc_provider.dart';
import 'package:botchan_client/bloc/bot_detail_bloc.dart';
import 'package:botchan_client/bloc/message_edit_bloc.dart';
import 'package:botchan_client/model/line_group_model.dart';
import 'package:botchan_client/model/message_edit_model.dart';
import 'package:botchan_client/model/partial/message.dart';
import 'package:botchan_client/model/partial/message/image_message.dart';
import 'package:botchan_client/model/partial/message/text_message.dart';
import 'package:botchan_client/utility/file_controller.dart';
import 'package:botchan_client/view/message_editor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

typedef OnSaveSuccess = void Function(LineGroupModel model);
class MessageEditable extends StatefulWidget {
  MessageEditable({
    Key key,
  }): super(key: key);

  @override
  _MessageEditableState createState() => new _MessageEditableState();
}

class _MessageEditableState extends State<MessageEditable> {
  TextEditingController textController = TextEditingController();
  MessageEditBloc _bloc;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<MessageEditBloc>(context);
    if (_bloc.getCurrentModel().message is TextMessage) {
      textController.text = (_bloc.getCurrentModel().message as TextMessage).text;
    }
    textController.addListener(textEditListener);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _bloc.messageEditStream,
      builder: (BuildContext context, AsyncSnapshot<MessageEditModel> snapshot) {
        if (snapshot.hasData) {
          return Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  child: Container(
                    constraints: BoxConstraints.loose(Size(200, 200)) ,
                    decoration: BoxDecoration(
                        color: Colors.green
                    ),
                    child: _buildMessageBlocks(snapshot.data.message),
                  )
              ),
              // テキスト編集時の完了ボタン
              Container(
                alignment: FractionalOffset(0.5, 1.0),
                child: _normalToolBar(),
              )
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildMessageBlocks(Message message) {
    switch (message.type) {
      case MessageType.TEXT:
        return _textBlock(message: message);
        break;
      case MessageType.IMAGE:
        textController.text = "";
        focusNode.unfocus(); //unfocus()でフォーカスが外れる
        return _imageBlock(message: message);
        break;
    }
    return Container();
  }

  Widget _textBlock({TextMessage message}) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: TextFormField(
        textAlign: TextAlign.start,
        maxLengthEnforced: true,
        maxLength: 30,
        focusNode: focusNode,
        keyboardType: TextInputType.multiline,
        maxLines: 4,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '入力してください',
          counterText: null,
        ),
        controller: textController,
      ),
    );
  }

  Widget _imageBlock({ImageMessage message}) {
    if (_bloc.getCachedImage() != null) {
      // ローカルキャッシュを表示
      return InkWell(
        onTap: () {
          _selectImage();
        },
        child: Image.memory( //変更
          _bloc.getCachedImage().readAsBytesSync(), //変更
          fit: BoxFit.contain,
        ),
      );
    } else if (_bloc.getImageUrl()?.isNotEmpty ?? false) {
      // from network
      return InkWell(
        onTap: () {
          _selectImage();
        },
        child: Image.network( //変更
          _bloc.getImageUrl(),
          fit: BoxFit.contain,
        ),
      );
    } else {
      // 画像なし
      return Padding(
        padding: EdgeInsets.all(5.0),
        child: Center(
            child: InkWell(
                onTap: () {
                  _selectImage();
                },
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.image),
                    Text("画像を選択する")
                  ],
                )
            )
        ),
      );
    }
  }

  void _selectImage() async {
    final file = await FileController.getImageFromDevice(ImageSource.gallery);
    if (file != null) {
      _bloc.saveImageCache(file);
    }
  }

  void textEditListener() {
    _bloc.changeMessageText(textController.text);
  }

  @override
  void dispose() {
    super.dispose();
    textController.removeListener(textEditListener);
    textController.dispose();
  }

  Widget _normalToolBar() {
    if (focusNode != null && focusNode.hasFocus == true) {
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
                  focusNode.unfocus(); //unfocus()でフォーカスが外れる
                },
              )
            ],
          ));
    } else {
      return Container();
    }
  }
}
