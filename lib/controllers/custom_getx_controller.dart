import 'package:get/get.dart';

class CustomGetXController extends GetxController {
  Map<dynamic, dynamic>? imageFile;
  bool isImagePicked = false;

  void updateImageFile(Map<dynamic, dynamic> newImageFile) {
    imageFile = newImageFile;
    isImagePicked = true;
    update();
  }
}
