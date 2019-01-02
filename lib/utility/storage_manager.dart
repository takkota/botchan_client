import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:botchan_client/utility/file_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart';
import 'image_controller.dart';
import 'package:uuid/uuid.dart';
import 'package:tuple/tuple.dart';

class StorageManager {
  static Future<Tuple2<String, String>> uploadImage(DecodeParam param) async {
    final storage = FirebaseStorage.instance;
    final String uuid = Uuid().v4();
    // original
    final StorageReference originalRef = storage.ref().child('images').child('original').child('$uuid.jpg');
    final StorageUploadTask originalTask = originalRef.putFile(
      param.file,
      StorageMetadata(
        contentLanguage: 'ja',
        contentType: 'image/jpeg',
      ),
    );
    // preview
    final StorageReference previewRef = storage.ref().child('images').child('preview').child('$uuid.jpg');
    final StorageUploadTask previewTask = previewRef.putFile(
      param.file,
      StorageMetadata(
        contentLanguage: 'ja',
        contentType: 'image/jpeg',
      ),
    );
    final originalUrl = await (await originalTask.onComplete).ref.getDownloadURL();
    final previewUrl = await (await previewTask.onComplete).ref.getDownloadURL();
    return Tuple2(originalUrl, previewUrl);
  }
}

class DecodeParam {
  final File file;
  final SendPort sendPort;
  DecodeParam(this.file, this.sendPort);
}
