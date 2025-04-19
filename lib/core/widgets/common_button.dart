import 'package:flutter/material.dart';
import 'package:image_fetcher/core/styles/fonts/font.dart';

class CommonButton extends StatelessWidget {
  const CommonButton(
      {super.key,
      required this.width,
      required this.height,
      required this.borderColor,
      required this.buttonColor,
      required this.buttonContent,
      required this.onTap});

  final double width;
  final double height;
  final Color borderColor;
  final Color buttonColor;
  final Widget buttonContent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: buttonColor,
            elevation: 0.0,
            textStyle: const TextStyle(fontFamily: Fonts.roboto),
            side: BorderSide(color: borderColor),
            //set border for the button
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          onPressed: onTap,
          child: buttonContent,
        ),
      ),
    );
  }
}
