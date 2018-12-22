import 'package:botchan_client/model/bot.dart';
import 'package:json_annotation/json_annotation.dart';

class BotListResponse {
  final List<Bot> botList;

  BotListResponse(this.botList);

  static BotListResponse fromJson(Map<String, dynamic> json) {
    List<Bot> list = List();
    for (Map<String, String> data in json["botList"]) {
      list.add(Bot());
    }
    return BotListResponse(list);
  }
}
