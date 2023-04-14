import 'package:eleven_ai/core/main_app.dart';
import 'package:flutter/material.dart';
import 'package:eleven_ai/core/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ElevenAI',
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.lightTheme,
      home: const MainApp(),
    );
  }
}
