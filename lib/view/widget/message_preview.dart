import 'dart:io';

import 'package:botchan_client/model/line_group_model.dart';
import 'package:botchan_client/model/partial/message.dart';
import 'package:botchan_client/model/partial/message/image_message.dart';
import 'package:botchan_client/model/partial/message/text_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef OnSaveSuccess = void Function(LineGroupModel model);

class MessagePreview extends StatelessWidget {
  MessagePreview({
    Key key,
    this.message,
  }): super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    if (message == null || !message.hasContent()) {
      // previewModeでMessage未設定
      return _noMessage();
    }
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
              child: _buildMessageBlocks(message),
            )
        ),
      ],
    );
  }

  Widget _buildMessageBlocks(Message message) {
    switch (message.type) {
      case MessageType.TEXT:
        return _textBlock(message: message as TextMessage);
        break;
      case MessageType.IMAGE:
        return _imageBlock(message: message as ImageMessage);
        break;
    }
    return Container();
  }

  Widget _textBlock({TextMessage message}) {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: Text(message.text)
    );
  }

  Widget _imageBlock({ImageMessage message}) {
    if (message.cachedImage != null) {
      // ローカルキャッシュを表示
      return Image.memory( //変更
        message.cachedImage.readAsBytesSync(), //変更
        fit: BoxFit.contain,
      );
    } else if (message.originalContentUrl.isNotEmpty ?? false) {
      // from network
      return Image.network( //変更
        message.originalContentUrl,
        fit: BoxFit.contain,
      );
    } else {
      // 画像なし
      return Padding(
        padding: EdgeInsets.all(5.0),
        child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.image),
                Text("画像を選択する")
              ],
            )
        ),
      );
    }
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
}
