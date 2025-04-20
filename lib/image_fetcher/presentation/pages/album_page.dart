import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_fetcher/core/styles/colors.dart';
import 'package:image_fetcher/gallery/presentation/bloc/image_gallery_cubit.dart';
import 'package:image_fetcher/gallery/presentation/widget/common_circular_loader.dart';
import 'package:image_fetcher/image_fetcher/presentation/bloc/image_fetcher_cubit.dart';
import 'package:image_fetcher/image_fetcher/presentation/widget/permission__handler_widget.dart';
import 'package:image_fetcher/gallery/presentation/pages/all_photos_view.dart';
import 'package:image_fetcher/core/dependencies/injectable.dart';

class AlbumPage extends StatelessWidget {
  const AlbumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ImageFetcherCubit, ImageFetcherState>(
          listener: (context, state) {
        if (state is ImageFetcherPermissionGranted) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BlocProvider(
                      create: (context) =>
                          getIt<ImageGalleryCubit>()..fetchAllImages(),
                      child: const AllPhotos(),
                    )),
          );
        }
      }, builder: (context, state) {
        switch (state) {
          case ImageFetcherLoadingState():
            return const CommonCircularLoader(loaderColor: AppColors.themeColor);
          case ImageFetcherInitial():
          case ImageFetcherPermissionPermanentlyDenied():
          case ImageFetcherPermissionDenied():
            return const PermissionHandlerWidget();
          default:
            return const PermissionHandlerWidget();
        }
      }),
    );
  }
}
