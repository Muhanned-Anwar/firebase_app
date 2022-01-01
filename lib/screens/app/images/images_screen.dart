import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vp7_firebase_app/get/images_getx_controller.dart';
import 'package:vp7_firebase_app/utils/helpers.dart';

class ImagesScreen extends StatefulWidget {
  const ImagesScreen({Key? key}) : super(key: key);

  @override
  _ImagesScreenState createState() => _ImagesScreenState();
}

class _ImagesScreenState extends State<ImagesScreen> with Helpers {
  ImagesGetxController controller = Get.put(ImagesGetxController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Images'),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/upload_image_screen'),
            icon: const Icon(Icons.cloud_upload_outlined),
          ),
        ],
      ),
      body: GetX<ImagesGetxController>(
        builder: (controller) {
          if (controller.references.isNotEmpty) {
            return GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              itemCount: controller.references.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) {
                return Card(
                    clipBehavior: Clip.antiAlias,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: FutureBuilder<String>(
                      future: controller.references[index].getDownloadURL(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasData &&
                            snapshot.data!.isNotEmpty) {
                          // return Image.network(snapshot.data!, fit: BoxFit.cover);
                          return Stack(
                            children: [
                              CachedNetworkImage(
                                cacheKey: 'fb_storage_${controller.references[index].name}',
                                imageUrl: snapshot.data!,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                fit: BoxFit.cover,
                                height: double.infinity,
                                width: double.infinity,
                              ),
                              Align(
                                alignment: AlignmentDirectional.bottomEnd,
                                child: Container(
                                  height: 40,
                                  color: Colors.black26,
                                  child: IconButton(
                                    onPressed: () async => await deleteImage(path: controller.references[index].fullPath),
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return const FlutterLogo(size: 80);
                        }
                      },
                    ));
              },
            );
          } else {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.warning, size: 80),
                  Text(
                    'No Data',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> deleteImage({required String path}) async {
    bool deleted = await ImagesGetxController.to.deleteImage(path: path);
    String message = deleted ? 'Image deleted successfully' : 'Failed to delete image';
    showSnackBar(context: context, message: message, error: !deleted);
  }
}
