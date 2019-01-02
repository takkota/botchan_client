import 'dart:io';

import 'package:botchan_client/model/line_group_model.dart';
import 'package:botchan_client/model/partial/message.dart';
import 'package:botchan_client/model/partial/push_schedule.dart';
import 'package:botchan_client/model/partial/reply_condition.dart';

class BotDetailModel {
  int botId;
  String title;
  BotType botType;
  List<LineGroupModel> lineGroups;
  ReplyCondition replyCondition;
  PushSchedule pushSchedule;
  Message message;

  BotDetailModel({
    this.botId,
    this.title = "",
    this.botType = BotType.REPLY,
    this.lineGroups = const [],
    this.replyCondition,
    this.pushSchedule,
    this.message
  }) {
    this.replyCondition = ReplyCondition(matchMethod: MatchMethod.PARTIAL);
    this.pushSchedule = PushSchedule(scheduleTime: DateTime.now().add(Duration(days: 1)));
  }
}

enum BotType {
  REPLY, PUSH
}
