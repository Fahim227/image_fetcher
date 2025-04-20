import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_fetcher/core/styles/colors.dart';
import 'package:image_fetcher/features/gallery/presentation/widget/common_circular_loader.dart';
import 'package:image_fetcher/gen/assets.gen.dart';

class PhotoCardView extends StatefulWidget {
  final File imageFile;
  final bool isSelected;
  final Function onSelected;
  const PhotoCardView({
    super.key,
    required this.imageFile,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  State<PhotoCardView> createState() => _PhotoCardViewState();
}

class _PhotoCardViewState extends State<PhotoCardView> {
  final isSelected = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    isSelected.value = widget.isSelected;
  }

  @override
  void dispose() {
    isSelected.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    return InkWell(
      onTap: () {
        isSelected.value = !isSelected.value;
        widget.onSelected.call(widget.imageFile);
      },
      child: ValueListenableBuilder<bool>(
        valueListenable: isSelected,
        builder: (context, value, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 84,
                width: 84,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: FutureBuilder<bool>(
                    future: isImageValid(
                        widget.imageFile), // checks if the file exists
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CommonCircularLoader(
                                loaderColor: AppColors.themeColor));
                      } else if (snapshot.hasError ||
                          !snapshot.hasData ||
                          !snapshot.data!) {
                        return const Center(
                          child: Icon(Icons.error, color: Colors.red),
                        );
                      } else {
                        final image = Image.file(
                          widget.imageFile,
                          fit: BoxFit.cover,
                          cacheWidth: (350 * devicePixelRatio).round(),
                        );
                        return value
                            ? ImageFiltered(
                                imageFilter:
                                    ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                child: image,
                              )
                            : image;
                      }
                    },
                  ),
                ),
              ),
              if (value) SvgPicture.asset(Assets.tickMark),
            ],
          );
        },
      ),
    );
  }

  Future<bool> isImageValid(File file) {
    return file.exists();
  }
}
