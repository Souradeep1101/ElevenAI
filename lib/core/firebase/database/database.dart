import 'package:eleven_ai/widgets/custom_snack_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Database {
  Future<DatabaseReference?> writeData({
    required FirebaseDatabase databaseReference,
    required String path,
    required Map<String, Object?> data,
    required bool overwriteData,
    required bool pushData,
    required BuildContext context,
  }) async {
    try {
      DatabaseReference ref = databaseReference.ref(path);
      if (pushData) {
        ref = databaseReference.ref(path).push();
      } else {
        ref = databaseReference.ref(path);
      }
      if (overwriteData) {
        await ref.set(data);
      } else {
        await ref.update(data);
      }
      return ref;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          message: 'Failed to send data to the database: $e',
          margin: const EdgeInsets.only(bottom: 200),
        ),
      );
      return null;
    }
  }

  Future<DataSnapshot?> readDataOnce(
      {required String path, required BuildContext context}) async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref(path);
      DatabaseEvent event = await ref.once();
      return event.snapshot;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          message: 'Failed to retrieve data from the database: $e',
          margin: const EdgeInsets.only(bottom: 200),
        ),
      );
      return null;
    }
  }
}
