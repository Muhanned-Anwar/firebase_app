import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vp7_firebase_app/get/images_getx_controller.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({Key? key}) : super(key: key);

  @override
  _UploadImageScreenState createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  double? _progressValue = 0;
  late ImagePicker _imagePicker;
  XFile? _pickedFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image'),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: _progressValue,
            color: Colors.blue.shade500,
            backgroundColor: Colors.grey.shade400,
            minHeight: 5,
          ),
          Expanded(
            child: _pickedFile != null
                ? Image.file(File(_pickedFile!.path))
                : TextButton(
                    onPressed: () async => await pickImage(),
                    child: const Text('Select Image'),
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20),
                      minimumSize: const Size(double.infinity, 0),
                    ),
                  ),
          ),
          ElevatedButton.icon(
            onPressed: () async => await uploadImage(),
            icon: const Icon(Icons.cloud_upload),
            label: const Text('Upload Image'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future pickImage() async {
    _imagePicker = ImagePicker();
    XFile? selectedImageFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (selectedImageFile != null) {
      setState(() {
        _pickedFile = selectedImageFile;
      });
    }
  }

  Future uploadImage() async {
    _changeProgressValue(value: null);
    if (_pickedFile != null) {
      ImagesGetxController.to.uploadImage(
          uploadListener: ({
            message,
            reference,
            required bool status,
            required TaskState taskState,
          }) {
            if (taskState == TaskState.running) {
              _changeProgressValue(value: null);
            } else if (taskState == TaskState.success) {
              _changeProgressValue(value: 1);
            } else if (taskState == TaskState.error) {
              _changeProgressValue(value: 0);
            }
          },
          file: File(_pickedFile!.path));
    }
  }

  void _changeProgressValue({required double? value}) {
    setState(() {
      _progressValue = value;
    });
  }

  void clearSelectedImage() {
    setState(() {
      _pickedFile = null;
    });
  }
}
