import 'package:botchan_client/model/bot_model.dart';
import 'package:json_annotation/json_annotation.dart';

class BotDetailResponse {
  final BotModel bot;

  BotDetailResponse(this.bot);

  static BotDetailResponse fromJson(Map<String, dynamic> json) {
    final bot = BotModel();
    return BotDetailResponse(bot);
  }
}
