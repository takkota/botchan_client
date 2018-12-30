import 'dart:async';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:botchan_client/model/message_edit_model.dart';
import 'package:botchan_client/model/partial/message.dart';
import 'package:botchan_client/model/partial/message/image_message.dart';
import 'package:botchan_client/model/partial/message/text_message.dart';
import 'package:rxdart/rxdart.dart';

class MessageEditBloc extends Bloc {
  MessageEditModel _model = MessageEditModel();

  // output entry point
  final BehaviorSubject<MessageEditModel> _behaviorSubject = BehaviorSubject<MessageEditModel>();
  Stream<MessageEditModel> get messageEditStream => _behaviorSubject.stream.asBroadcastStream();

  MessageEditBloc({Message message}) {
    this._model = MessageEditModel(message: message);
    _behaviorSubject.sink.add(_model);
  }

  void changeMessageType(MessageType type) {
    switch (type) {
      case MessageType.TEXT:
        _model.message = TextMessage();
        break;
      case MessageType.IMAGE:
        _model.message = ImageMessage();
        break;
    }
    _behaviorSubject.sink.add(_model);
  }

  void changeMessageText(String text) {
    if (_model.message is TextMessage) {
      (_model.message as TextMessage)..text = text;
    }
    _behaviorSubject.sink.add(_model);
  }


  void uploadImage(String text) {
    // originalContent
    // previewImage
  }

  @override
  void dispose() async {
    _behaviorSubject.close();
  }

}
