import 'package:botchan_client/model/bot_model.dart';
import 'package:botchan_client/model/partial/message.dart';
import 'package:botchan_client/model/partial/push_schedule.dart';
import 'package:botchan_client/model/partial/reply_condition.dart';

class BotDetailModel {
  String botId;
  String title;
  BotType botType;
  List<String> groupIds;
  ReplyCondition replyCondition = ReplyCondition();
  PushSchedule pushSchedule = PushSchedule(scheduleTime: DateTime.now().add(Duration(days: 1)));
  Message message;

  BotDetailModel({
    this.botId,
    this.title = "",
    this.botType = BotType.REPLY,
    this.groupIds = const [],
    this.message
  });
}
