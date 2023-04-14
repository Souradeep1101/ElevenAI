import 'package:eleven_ai/widgets/custom_profile_image_avatar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eleven_ai/screens/user/edit_profile_screen.dart';
import 'package:eleven_ai/widgets/custom_elevated_button.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16,
          top: 10,
        ),
        child: ListView(
          children: [
            Text(
              'Profile',
              style: GoogleFonts.nunitoSans(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: CustomProfileImageAvatar(
                imageUrl: FirebaseAuth.instance.currentUser?.photoURL,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              '${FirebaseAuth.instance.currentUser!.displayName}',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 8),
            Text(
              '${FirebaseAuth.instance.currentUser!.email}',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(height: 32),
            Center(
              child: SizedBox(
                width: double.maxFinite,
                child: CustomElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
                      ),
                    );
                  },
                  text: 'Edit Profile',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
