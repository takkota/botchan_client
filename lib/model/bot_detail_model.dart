import 'package:botchan_client/network/request/push_schedule.dart';
import 'package:botchan_client/network/request/reply_condition.dart';

class BotDetailModel {
  String botId;
  String title;
  BotType botType;
  List<int> groupIds;
  ReplyCondition replyCondition = ReplyCondition();
  PushSchedule pushSchedule = PushSchedule(scheduleTime: DateTime.now().add(Duration(days: 1)));

  BotDetailModel({
    this.botId,
    this.title = "",
    this.botType = BotType.REPLY,
    this.groupIds = const []
  });
}

enum BotType {
  REPLY, PUSH
}
