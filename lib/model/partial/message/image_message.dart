import 'dart:io';

import 'package:botchan_client/model/partial/message.dart';

class ImageMessage extends Message {

  String originalContentUrl;

  String previewImageUrl;
  // ローカル用
  File cachedImage;

  ImageMessage({this.originalContentUrl, this.previewImageUrl}): super(MessageType.IMAGE);

  static ImageMessage fromJson(Map<String, dynamic> json) {
    return ImageMessage()
      ..originalContentUrl = json["originalContentUrl"]
      ..previewImageUrl = json["previewImageUrl"];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "type": "image",
      "originalContentUrl": originalContentUrl,
      "previewImageUrl": previewImageUrl,
    };
  }

  @override
  bool hasContent() {
    if (cachedImage != null) return true;
    if (originalContentUrl?.isNotEmpty ?? false) return true;
    if (previewImageUrl?.isNotEmpty ?? false) return true;
    return false;
  }
}