import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

typedef UploadListener = void Function({
  String? message,
  Reference? reference,
  required bool status,
  required TaskState taskState,
});

class FbStorageController {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<void> uploadImage({
    required File file,
    required UploadListener uploadListener,
  }) async {
    UploadTask uploadTask =
        _firebaseStorage.ref('images/${DateTime.now()}.png').putFile(file);
    uploadTask.snapshotEvents.listen((event) {
      if (event.state == TaskState.running) {
        uploadListener(status: false, taskState: event.state);
      } else if (event.state == TaskState.success) {
        uploadListener(
          status: true,
          reference: event.ref,
          message: 'Image uploaded successfully',
          taskState: event.state,
        );
      } else if (event.state == TaskState.error) {
        uploadListener(
          status: false,
          message: 'Failed to upload image, something went wrong',
          taskState: event.state,
        );
      }
    });
  }

  Future<List<Reference>> getImages() async {
    ListResult listResult = await _firebaseStorage.ref('images').listAll();
    if (listResult.items.isNotEmpty) {
      return listResult.items;
    }
    return [];
  }

  Future<bool> deleteImage({required String path}) async {
    return await _firebaseStorage
        .ref(path)
        .delete()
        .then((value) => true)
        .catchError((error) => false);
  }
}
