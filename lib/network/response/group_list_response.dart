import 'package:botchan_client/model/bot_model.dart';
import 'package:botchan_client/model/line_group_model.dart';
import 'package:json_annotation/json_annotation.dart';

class LineGroupListResponse {
  final List<LineGroupModel> lineGroupList;

  LineGroupListResponse(this.lineGroupList);

  static LineGroupListResponse fromJson(Map<String, dynamic> json) {
    List<LineGroupModel> list = List();
    for (Map<String, String> data in json["lineGroupList"]) {
      list.add(LineGroupModel(id: data["id"], displayName: data["displayName"]));
    }
    return LineGroupListResponse(list);
  }
}
