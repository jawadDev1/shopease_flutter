import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopeease/screens/bottomnav.dart';
import 'package:shopeease/screens/auth/login.dart';
import 'package:shopeease/testCode.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final auth = FirebaseAuth.instance;

  late final user;

  @override
  void initState() {
    super.initState();
    user = auth.currentUser;

    if (user != null) {
      Timer(
          Duration(seconds: 4),
          () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => BottomNav())));
    } else {
      Timer(
          Duration(seconds: 4),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext context) => Login())));
    }
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 16, 16, 28),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('images/logo.png'),
                  radius: 60,
                ),
                Text(
                  "Unlock Knowledge, Quiz Your Way!",
                  style: TextStyle(
                      fontSize: 20, color: Colors.white, fontFamily: 'Roboto'),
                ),
                SizedBox(
                  height: 34,
                ),
                CircularProgressIndicator(
                  backgroundColor: Colors.white,
                )
              ]),
        ),
      ),
    );
  }
}
