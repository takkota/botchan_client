import 'package:botchan_client/model/bot.dart';
import 'package:json_annotation/json_annotation.dart';

class BotDetailResponse {
  final Bot bot;

  BotDetailResponse(this.bot);

  static BotDetailResponse fromJson(Map<String, dynamic> json) {
    final bot = Bot();
    return BotDetailResponse(bot);
  }
}
