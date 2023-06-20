import 'package:flutter/material.dart';
import 'package:social_app/Screen/auth/authPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:social_app/theme/darkTheme.dart';
import 'package:social_app/theme/lightTheme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const ThemeMode themeMode = ThemeMode.system;

    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      home: const AuthPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
