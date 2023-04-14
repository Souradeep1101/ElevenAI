import 'dart:io';
import 'package:eleven_ai/widgets/custom_snack_bar.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Storage {
  final storage = FirebaseStorage.instance;

  Future<bool> uploadFile({
    required String filePath,
    required String fileName,
    required String directory,
    required BuildContext context,
  }) async {
    File file = File(filePath);
    try {
      await storage.ref('$directory/$fileName').putFile(file);
      return true;
    } on firebase_core.FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          message: 'Failed to upload file to cloud: $e',
          margin: const EdgeInsets.only(bottom: 200),
        ),
      );
      return false;
    }
  }
}
