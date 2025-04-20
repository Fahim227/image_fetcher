import 'package:flutter/material.dart';

class CommonCircularLoader extends StatelessWidget {
  final Color loaderColor;
  const CommonCircularLoader({super.key, required this.loaderColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: loaderColor,
            ),
          ),
        ),

      ],
    );
  }
}
