import 'package:eleven_ai/core/firebase/user/auth.dart';
import 'package:eleven_ai/widgets/custom_elevated_button.dart';
import 'package:eleven_ai/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _darkModeEnabled = false;
  bool _notificationsEnabled = true;

  void _toggleDarkMode(bool value) {
    setState(() {
      _darkModeEnabled = value;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackBar(
        message: 'Coming Soon!',
        margin: const EdgeInsets.only(bottom: 200),
      ),
    );
  }

  void _toggleNotifications(bool value) {
    setState(() {
      _notificationsEnabled = value;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackBar(
        message: 'Coming Soon!',
        margin: const EdgeInsets.only(bottom: 200),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: theme.primaryColor,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: theme.primaryColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'General Settings',
                style: GoogleFonts.nunitoSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Dark mode',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: theme.primaryColor,
                    ),
                  ),
                  Switch(
                    value: _darkModeEnabled,
                    onChanged: _toggleDarkMode,
                    activeColor: theme.colorScheme.tertiary,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Notifications',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: theme.primaryColor,
                    ),
                  ),
                  Switch(
                    value: _notificationsEnabled,
                    onChanged: _toggleNotifications,
                    activeColor: theme.colorScheme.tertiary,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: SizedBox(
                  width: double.maxFinite,
                  child: CustomElevatedButton(
                    onPressed: () async {
                      await Auth().signOut(context: context);
                    },
                    text: 'Log Out',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
