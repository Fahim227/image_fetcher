import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_fetcher/core/styles/text_style/app_text_style.dart';
import 'package:image_fetcher/core/widgets/common_button.dart';

import 'package:image_fetcher/core/styles/colors.dart';
import 'package:image_fetcher/features/gallery/presentation/bloc/image_gallery_cubit.dart';
import 'package:image_fetcher/features/gallery/presentation/widget/photo_card_view.dart';

import 'package:image_fetcher/features/gallery/presentation/widget/common_circular_loader.dart';

class AllPhotos extends StatefulWidget {
  const AllPhotos({super.key});

  @override
  State<AllPhotos> createState() => _AllPhotosState();
}

class _AllPhotosState extends State<AllPhotos> {
  final _scrollController = ScrollController();
  final List<File> selectedImages = [];
  final isDownloading = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        context.read<ImageGalleryCubit>().loadMoreImages();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleImageSelected(selectedPath) {
    if (!selectedImages.contains(selectedPath)) {
      selectedImages.add(selectedPath);
    } else {
      selectedImages.remove(selectedPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      floatingActionButton: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
          child: ValueListenableBuilder<bool>(
            valueListenable: isDownloading,
            builder: (context, isLoading, child) {
              return CommonButton(
                width: size.width,
                height: 42,
                borderColor: AppColors.themeColor,
                buttonColor: AppColors.themeColor,
                buttonContent: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isLoading) ...[
                      const CommonCircularLoader(
                        loaderColor: Colors.black,
                      ),
                      const SizedBox(
                        width: 8,
                      )
                    ],
                    Text(
                      "DOWNLOAD",
                      style: AppTextStyle.getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  ],
                ),
                onTap: () async {
                  isDownloading.value = true;
                  await context
                      .read<ImageGalleryCubit>()
                      .saveAllImages(selectedImages);
                  isDownloading.value = false;
                },
              );
            },
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: BlocConsumer<ImageGalleryCubit, ImageGalleryState>(
        listener: (context, state) {},
        builder: (context, state) {

          switch (state) {
            case ImageGalleryInitial():
            case ImageGalleryLoading():
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.themeColor,
                ),
              );
            case ImageGalleryLoaded():
              final imageList = state.allImages;
              print("images===== ${imageList.length}");
              print("has More===== ${state.hasMore}");
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new),
                      onPressed: () {
                        Navigator.of(context)
                            .pop(); // Navigates back to the previous screen
                      },
                    ),
                    title: Text(
                      'Photos',
                      style: AppTextStyle.getTextStyle(fontSize: 20),
                    ),
                    pinned: true,
                    floating: true,
                    snap: true,
                    backgroundColor: Colors.white, // Customize as needed
                    centerTitle: true,
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      height: size.height - 100,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: GridView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.zero,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: imageList.length,
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          final imageFile = imageList[index];

                          return PhotoCardView(
                            imageFile: imageFile,
                            isSelected: false,
                            onSelected: _handleImageSelected,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
          }
        },
      ),
    );
  }
}
