import 'package:botchan_client/model/bot_model.dart';
import 'package:json_annotation/json_annotation.dart';

class BotListResponse {
  final List<BotModel> botList;

  BotListResponse(this.botList);

  static BotListResponse fromJson(Map<String, dynamic> json) {
    List<BotModel> list = List();
    for (Map<String, String> data in json["botList"]) {
      list.add(BotModel(botId: data["botId"], title: data["name"]));
    }
    return BotListResponse(list);
  }
}
