import 'package:flutter/material.dart';

class AppWidget {
  static TextStyle boldTextStyle() {
    return TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Montserrat-Bold',
    );
  }

  static TextStyle headingTextStyle() {
    return TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        fontFamily: 'Montserrat-Bold',
        color: Colors.black);
  }

  static TextStyle categoryTextStyle() {
    return TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Montserrat-Bold',
      color: Colors.white,
    );
  }

  static TextStyle cardTextStyle() {
    return TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Montserrat-Regular',
      color: Colors.white,
    );
  }

  static TextStyle productTitleStyle() {
    return TextStyle(
      color: Colors.white,
      fontSize: 25.0,
      fontWeight: FontWeight.w600,
      fontFamily: 'Montserrat-Bold',
    );
  }
}
