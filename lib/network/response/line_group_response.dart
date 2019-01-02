import 'package:botchan_client/model/line_group_model.dart';
import 'package:json_annotation/json_annotation.dart';

class LineGroupResponse {
  final LineGroupModel lineGroupModel;

  LineGroupResponse(this.lineGroupModel);

  static LineGroupResponse fromJson(Map<String, dynamic> json) {
      return LineGroupResponse(
        LineGroupModel(
            id: json["id"],
            lineGroupId: json["lineGroupId"],
            displayName: json["displayName"]
        )
      );
  }
}
