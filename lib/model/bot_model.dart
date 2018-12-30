import 'package:botchan_client/model/bot_detail_model.dart';
import 'package:botchan_client/model/partial/message.dart';

class BotModel {
  String botId;
  String title;
  BotType botType;
  List<String> groupIds = const [];
  Message message;
  BotModel({this.title, this.botId, this.botType, this.groupIds, this.message});
}

enum BotType {
  REPLY, PUSH
}
