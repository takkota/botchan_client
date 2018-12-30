import 'package:botchan_client/model/partial/message.dart';
import 'package:botchan_client/model/partial/message/text_message.dart';

class MessageEditModel {
  Message message;

  MessageEditModel({Message message}) {
    if (message != null) {
      this.message = message;
    } else {
      this.message = TextMessage();
    }
  }
}
