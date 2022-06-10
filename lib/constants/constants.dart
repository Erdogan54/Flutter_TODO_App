
import 'package:flutter/material.dart';

class Constants {
  Constants._();

  static TextStyle getIsNotComlateTextStyle() {
    return const TextStyle(color: Colors.black);
  }

  static TextStyle getComlateTextStyle() {
    return TextStyle(
        decoration: TextDecoration.lineThrough,
        color: Colors.black.withOpacity(0.5));
  }
}
