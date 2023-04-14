import 'package:eleven_ai/core/firebase/user/auth.dart';
import 'package:eleven_ai/widgets/custom_elevated_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eleven_ai/screens/content/dashboard.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool _isLoading = false;
  bool _isError = false;

  Future<void> _verifyEmail() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      await FirebaseAuth.instance.currentUser!.reload();
      while (!FirebaseAuth.instance.currentUser!.emailVerified) {
        await Future.delayed(const Duration(seconds: 2));
        await FirebaseAuth.instance.currentUser!.reload();
      }

      setState(() {
        _isLoading = false;
        _isError = false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Dashboard(),
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                Text(
                  'Verify your email',
                  style: Theme.of(context).textTheme.headline2,
                ),
                const SizedBox(height: 10),
                Text(
                  'A verification link has been sent to your email address. Please click the link to verify your account.',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(height: 40),
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                else if (_isError)
                  Center(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 50,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'An error occurred while verifying your email address. Please try again later.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(color: Colors.red),
                        ),
                      ],
                    ),
                  )
                else
                  Center(
                    child: CustomElevatedButton(
                      onPressed: _verifyEmail,
                      text: 'Verify Email',
                    ),
                  ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () async {
                        await Auth().signOut(context: context);
                      },
                      child: Text(
                        'Back to Login',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
