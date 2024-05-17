import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopeease/screens/bottomnav.dart';
import 'package:shopeease/screens/auth/login.dart';
import 'package:shopeease/utils/theme.dart';

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
        backgroundColor: AppTheme.primary,
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 62,
                  color: AppTheme.white,
                ),
                Text(
                  "ShopEase",
                  style: TextStyle(
                      fontSize: 30, color: Colors.white, fontFamily: 'Roboto'),
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
