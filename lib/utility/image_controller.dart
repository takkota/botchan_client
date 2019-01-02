import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:image/image.dart';

class ImageController {
  static Future<Image> resizeImage(File file, int maxSize) async {
    // Read a jpeg image from file.
    Image image = decodeImage(file.readAsBytesSync());
    // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).
    return copyResize(image, maxSize);
  }

  static Future<List<int>> convertToJpg(Image image) async {
    return encodeJpg(image);
  }
}

