import 'package:botchan_client/model/bot_detail_model.dart';
import 'package:botchan_client/network/response/bot_detail_response.dart';

class BotListResponse {
  final List<BotDetailModel> botList;

  BotListResponse(this.botList);

  static BotListResponse fromJson(Map<String, dynamic> json) {
    List<BotDetailModel> list = List();

    for (Map<String, dynamic> data in json["botList"]) {
      list.add(BotDetailResponse.fromJson(data).bot);
    }
    return BotListResponse(list);
  }
}
