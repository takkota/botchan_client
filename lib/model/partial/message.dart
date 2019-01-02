import 'package:botchan_client/model/partial/message/image_message.dart';
import 'package:botchan_client/model/partial/message/text_message.dart';

abstract class Message {
  MessageType type = MessageType.TEXT;
  final QuickReply quickReply;

  Message(this.type, {this.quickReply});

  factory Message.fromJson(Map<String, dynamic> json) {
    String type = json["type"];
    switch (type) {
      case "text":
        return TextMessage.fromJson(json);
      case "image":
        return ImageMessage.fromJson(json);
    }
    return TextMessage.fromJson(json);
  }

  Map<String, dynamic> toJson();
  bool hasContent();
}

enum MessageType {
  TEXT, IMAGE
}

class QuickReply {
  List<QuickReplyItem> items;
}

abstract class QuickReplyItem {
  String type;
  String imageUrl;
  Action action;
}

abstract class Action {
  String label;
}
