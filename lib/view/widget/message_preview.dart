
import 'package:botchan_client/model/line_group_model.dart';
import 'package:botchan_client/model/partial/message.dart';
import 'package:botchan_client/model/partial/message/image_message.dart';
import 'package:botchan_client/model/partial/message/text_message.dart';
import 'package:botchan_client/model/partial/message/video_message.dart';
import 'package:botchan_client/view/widget/line_bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

typedef OnSaveSuccess = void Function(LineGroupModel model);

class MessagePreview extends StatelessWidget {
  MessagePreview({
    Key key,
    this.message,
  }): super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    return LineBubble(
      child: _buildMessageBlocks(message),
      hasNip: message is TextMessage,
    );
  }

  Widget _buildMessageBlocks(Message message) {
    switch (message.type) {
      case MessageType.TEXT:
        return _textBlock(message: message as TextMessage);
        break;
      case MessageType.IMAGE:
        return _imageBlock(message: message as ImageMessage);
      case MessageType.VIDEO:
        return _videoBlock(message: message as VideoMessage);
      case MessageType.FLEX:
        return Container(); //_imageBlock(message: message as FlexMessage);
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

  Widget _videoBlock({VideoMessage message}) {
    if (message.cachedVideo != null) {
      // ローカルキャッシュを表示
      final playerWidget = new Chewie(
        VideoPlayerController.file(
          message.cachedVideo
        ),
        autoPlay: true,
        looping: true,
      );
      return playerWidget;
    } else if (message.originalContentUrl.isNotEmpty ?? false) {
      // from network
      final playerWidget = new Chewie(
        VideoPlayerController.network(
            message.originalContentUrl
        ),
        autoPlay: true,
        looping: true,
      );
      return playerWidget;
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
}
