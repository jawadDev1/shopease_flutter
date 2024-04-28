import 'package:flutter/material.dart';
import 'package:shopeease/screens/auth/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shopeease/screens/splash.dart';
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shop Ease',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 6, 4, 104)),
        useMaterial3: true,
      ),
      home: Splash(),
    );
  }
}