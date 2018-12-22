import 'package:json_annotation/json_annotation.dart';

class AccountLinkedResponse {
  final bool isLinked;

  AccountLinkedResponse(this.isLinked);

  static AccountLinkedResponse fromJson(Map<String, dynamic> json) {
    return AccountLinkedResponse(json["isLinked"]);
  }
}
