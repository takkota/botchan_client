import 'package:botchan_client/model/partial/message.dart';

class ImageMessage extends Message {

  String originalContentUrl;

  String previewImageUrl;

  ImageMessage({this.originalContentUrl, this.previewImageUrl}): super(MessageType.IMAGE);

  static ImageMessage fromJson(Map<String, dynamic> json) {
    return ImageMessage()
      ..originalContentUrl = json["originalContentUrl"]
      ..previewImageUrl = json["previewImageUrl"];
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    return null;
  }

  @override
  bool hasInputAny() {
    if (originalContentUrl?.isNotEmpty ?? false) return true;
    if (previewImageUrl?.isNotEmpty ?? false) return true;
    return false;
  }
}