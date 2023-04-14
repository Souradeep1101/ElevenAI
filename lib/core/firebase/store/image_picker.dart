import 'package:eleven_ai/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickImage {
  Future<Map<dynamic, dynamic>?> pickImage({
    ImageSource source = ImageSource.camera,
    required BuildContext context,
  }) async {
    try {
      XFile? pickedFile = await ImagePicker().pickImage(source: source);
      return {
        'image_file': pickedFile,
        'path': pickedFile!.path,
        'file_name': pickedFile.name
      };
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          message: 'Failed to pick image: $e',
          margin: const EdgeInsets.only(bottom: 200),
        ),
      );
      return null;
    }
  }
}
