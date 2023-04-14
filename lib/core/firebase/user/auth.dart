import 'package:eleven_ai/core/main_app.dart';
import 'package:eleven_ai/widgets/custom_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> loginUser(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            message: 'The password provided is too weak.',
            margin: const EdgeInsets.only(bottom: 200),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            message: 'The account already exists for that email.',
            margin: const EdgeInsets.only(bottom: 200),
          ),
        );
      } else if (e.code == 'account-exists-with-different-credential') {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            message:
                'The account already exists for that email with different credentials.',
            margin: const EdgeInsets.only(bottom: 200),
          ),
        );
      } else if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            message: 'No account exists with these credentials.',
            margin: const EdgeInsets.only(bottom: 200),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            message: e.message!,
            margin: const EdgeInsets.only(bottom: 200),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          message: 'Failed to login user with email and password: $e',
          margin: const EdgeInsets.only(bottom: 200),
        ),
      );
    }
    return null;
  }

  // Register user with email and password
  Future<User?> registerUser({
    required String email,
    required String password,
    required BuildContext context,
    required String name,
  }) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user!.updateDisplayName(name);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        CustomSnackBar(
          message: 'Failed to register user with email and password: $e',
          margin: const EdgeInsets.only(bottom: 200),
        ),
      );
      return null;
    }
  }

  // Sign out user
  Future<void> signOut({required BuildContext context}) async {
    await _firebaseAuth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MainApp(),
      ),
    );
  }
}
