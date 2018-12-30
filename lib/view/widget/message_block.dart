
import 'package:botchan_client/model/partial/message.dart';
import 'package:botchan_client/model/partial/message/text_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget buildMessageBlock(
    Message message,
    bool isPreview,
    TextEditingController textEditController,
    {
      VoidCallback onEditComplete,
      VoidCallback onTapImage
    }) {
  List<Widget> buildBlocks() {
    List<Widget> blocks = [];
    switch (message.type) {
      case MessageType.TEXT:
        blocks.add(
            textBlock(
                message: message as TextMessage,
                textEditController: textEditController,
                onEditComplete: onEditComplete
            )
        );
        break;
      case MessageType.IMAGE:
        break;
    }
    return blocks;
  }

  return Column(
    children: buildBlocks()
  );
}

Widget textBlock({TextMessage message, TextEditingController textEditController, VoidCallback onEditComplete}) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30.0))
    ),
    child: Center(
      child: TextFormField(
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: '入力してください'
        ),
        onEditingComplete: () {
          onEditComplete();
        },
        initialValue: message.text,
      ),
    ),
  );
}
