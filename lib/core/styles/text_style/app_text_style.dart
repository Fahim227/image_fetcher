import 'package:flutter/material.dart';
import 'package:image_fetcher/core/styles/fonts/font.dart';

class AppTextStyle {
  static TextStyle getTextStyle({
    double fontSize = 14.0,
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.w400,
    String fontFamily = Fonts.roboto,
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
    );
  }
}
