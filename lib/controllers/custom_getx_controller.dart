import 'package:get/get.dart';

class CustomGetXController extends GetxController {
  Map<dynamic, dynamic>? imageFile;
  bool isImagePicked = false;
  String? apiKey;

  void updateImageFile(Map<dynamic, dynamic> newImageFile) {
    imageFile = newImageFile;
    isImagePicked = true;
    update();
  }

  void updateApiKey({required String? apiKey}) {
    this.apiKey = apiKey;
  }
}
