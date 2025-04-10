import 'package:flutter/material.dart';

class AppWidget {
  static TextStyle boldTextfeildStyle() {
    return const TextStyle(
        color: Colors.black,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins');
  }

  static TextStyle HeadlineTextfeildStyle() {
    return const TextStyle(
        color: Colors.black,
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins');
  }

  static TextStyle LightTextfeildStyle() {
    return const TextStyle(
        color: Colors.grey,
        fontSize: 15.0,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins');
  }

  static TextStyle semiBoldTextfeildStyle() {
    return const TextStyle(
        color: Colors.black,
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins');
  }
}
