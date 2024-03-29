import 'package:botchan_client/model/line_group_model.dart';
import 'package:botchan_client/network/response/line_group_response.dart';

class LineGroupListResponse {
  final List<LineGroupModel> lineGroupList;

  LineGroupListResponse(this.lineGroupList);

  static LineGroupListResponse fromJson(Map<String, dynamic> json) {
    List<LineGroupModel> list = List();

    for (Map<String, dynamic> data in json["lineGroupList"]) {
      list.add(LineGroupResponse.fromJson(data).lineGroupModel);
    }
    return LineGroupListResponse(list);
  }
}
