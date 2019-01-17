import 'dart:io';

import 'package:botchan_client/model/partial/message.dart';

class VideoMessage extends Message {

  String originalContentUrl;

  String previewImageUrl;
  // ローカル用
  File cachedVideo;

  VideoMessage({this.originalContentUrl, this.previewImageUrl}): super(MessageType.VIDEO);

  static VideoMessage fromJson(Map<String, dynamic> json) {
    return VideoMessage()
      ..originalContentUrl = json["originalContentUrl"]
      ..previewImageUrl = json["previewImageUrl"];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "type": "video",
      "originalContentUrl": originalContentUrl,
      "previewImageUrl": previewImageUrl,
    };
  }

  @override
  bool hasContent() {
    if (cachedVideo != null) return true;
    if (originalContentUrl?.isNotEmpty ?? false) return true;
    if (previewImageUrl?.isNotEmpty ?? false) return true;
    return false;
  }
}