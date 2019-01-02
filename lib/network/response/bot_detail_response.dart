import 'package:botchan_client/model/bot_detail_model.dart';
import 'package:botchan_client/model/partial/message.dart';
import 'package:botchan_client/model/partial/push_schedule.dart';
import 'package:botchan_client/model/partial/reply_condition.dart';
import 'package:botchan_client/network/response/line_group_response.dart';

class BotDetailResponse {
  final BotDetailModel bot;

  BotDetailResponse(this.bot);

  static BotDetailResponse fromJson(Map<String, dynamic> json) {
    BotType botType;
    botType = json["botType"] == "reply" ? BotType.REPLY : BotType.PUSH;

    final bot = BotDetailModel(
      botType: botType,
      botId: json["botId"],
      title: json["title"],
      message: Message.fromJson(json["message"])
    );

    if (json["lineGroups"] != null) {
      final list = List.from(json["lineGroups"]);
      bot.lineGroups = list.map((data) {
        return LineGroupResponse.fromJson(data).lineGroupModel;
      }).toList();
    }

    if (json["pushSchedule"] != null) {
      final pushSchedule = json["pushSchedule"];
      bot.pushSchedule = PushSchedule(
        id: pushSchedule["id"],
        botId: pushSchedule["botId"],
        days: PushSchedule.convertBitFlagToDays(pushSchedule["days"]),
        scheduleTime: DateTime.parse(pushSchedule["scheduleTime"])
      );
    }

    if (json["replyCondition"] != null) {
      final replyCondition = json["replyCondition"];
      bot.replyCondition = ReplyCondition(
        id: replyCondition["id"],
        botId: replyCondition["botId"],
        keyword: replyCondition["keyword"],
        matchMethod: replyCondition["matchMethod"] == "partial" ? MatchMethod.PARTIAL : MatchMethod.EXACT,
      );
    }
    return BotDetailResponse(bot);
  }
}
