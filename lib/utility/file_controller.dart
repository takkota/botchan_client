import 'dart:async';
import 'dart:io'; // 追加
import 'package:botchan_client/utility/image_controller.dart';
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

class FileController {
  // ドキュメントのパスを取得
  static Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // 画像をキャッシュとして保存する。
  static Future<File> saveLocalFile(File file) async {
    final path = await localPath;
    final file = File('$path/original_image.png');
    var savedFile = file.writeAsBytes(await file.readAsBytes());

    return savedFile;
  }

  static Future<File> getImageFromDevice(ImageSource source) async {
    var imageFile = await ImagePicker.pickImage(source: source);

    if (imageFile == null) {
      return null;
    }
    return imageFile;
  }

  static Future<File> getVideoFromDevice(ImageSource source) async {
    var videoFile = await ImagePicker.pickVideo(source: source);

    if (videoFile == null) {
      return null;
    }
    return videoFile;
  }
}