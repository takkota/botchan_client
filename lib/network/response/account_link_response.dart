import 'package:json_annotation/json_annotation.dart';

class AccountLinkResponse {
  final String linkUrl;

  AccountLinkResponse(this.linkUrl);

  static AccountLinkResponse fromJson(Map<String, dynamic> json) {
    return AccountLinkResponse(json["linkUrl"]);
  }
}
