import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:vp7_firebase_app/fb_controllers/fb_storage_controller.dart';

class ImagesGetxController extends GetxController {
  static ImagesGetxController get to => Get.find();
  final FbStorageController _fbStorageController = FbStorageController();
  RxList<Reference> references = <Reference>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getImages();
    super.onInit();
  }

  Future<void> uploadImage(
      {required UploadListener uploadListener, required File file}) async {
    _fbStorageController.uploadImage(
      file: file,
      uploadListener: (
          {String? message,
          Reference? reference,
          required bool status,
          required TaskState taskState}) {

        if(status && reference != null){
          references.add(reference);
        }
        uploadListener(taskState: taskState, status: status, message: message);
      },
    );
  }

  Future<void> getImages() async {
    references.value = await _fbStorageController.getImages();
  }

  Future<bool> deleteImage({required String path}) async {
    bool deleted = await _fbStorageController.deleteImage(path: path);
    if(deleted) {
      references.removeWhere((element) => element.fullPath == path);
    }
    return deleted;
  }
}
