import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../gen/assets.gen.dart';

class PhotoCardView extends StatefulWidget {
  final String imagePath;
  final bool isSelected;
  final Function onSelected;
  const PhotoCardView({
    super.key,
    required this.imagePath,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  State<PhotoCardView> createState() => _PhotoCardViewState();
}

class _PhotoCardViewState extends State<PhotoCardView> {
  late bool isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    final file = File(widget.imagePath);
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    return InkWell(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
        widget.onSelected.call(widget.imagePath);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 84,
            width: 84,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: isSelected
                  ? ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Image.file(
                  file,
                  fit: BoxFit.cover,
                  cacheWidth: (350 * devicePixelRatio).round(),
                ),
              )
                  : Image.file(
                file,
                fit: BoxFit.cover,
                cacheWidth: (350 * devicePixelRatio).round(),
              ),
            ),
          ),
          if (isSelected) SvgPicture.asset(Assets.tickMark),
        ],
      ),
    );
  }
}
