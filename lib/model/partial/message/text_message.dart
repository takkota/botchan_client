import 'package:botchan_client/model/partial/message.dart';

class TextMessage extends Message {
  String text;

  TextMessage({this.text}): super(MessageType.TEXT);

  static TextMessage fromJson(Map<String, dynamic> json) {
    return TextMessage()
        ..text = json["text"];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "type": "text",
      "text": text,
    };
  }

  @override
  bool hasContent() {
    return text?.isNotEmpty ?? false;
  }
}