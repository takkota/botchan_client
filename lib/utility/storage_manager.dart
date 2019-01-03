import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:tuple/tuple.dart';

class StorageManager {
  static Future<Tuple2<String, String>> uploadImage(File file) async {
    final storage = FirebaseStorage.instance;
    final String uuid = Uuid().v4();
    // original
    final StorageReference originalRef = storage.ref().child('images').child('original').child('$uuid.jpg');
    final StorageUploadTask originalTask = originalRef.putFile(
      file,
      StorageMetadata(
        contentLanguage: 'ja',
        contentType: 'image/jpeg',
      ),
    );
    // preview
    final StorageReference previewRef = storage.ref().child('images').child('preview').child('$uuid.jpg');
    final StorageUploadTask previewTask = previewRef.putFile(
      file,
      StorageMetadata(
        contentLanguage: 'ja',
        contentType: 'image/jpeg',
      ),
    );
    var originalUrl = await (await originalTask.onComplete).ref.getDownloadURL();
    originalUrl = originalUrl.toString().split("&token=")[0];
    var previewUrl = await (await previewTask.onComplete).ref.getDownloadURL();
    previewUrl = previewUrl.toString().split("&token=")[0];
    return Tuple2(originalUrl, previewUrl);
  }
}
