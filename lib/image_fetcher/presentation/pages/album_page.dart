import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_fetcher/core/styles/colors.dart';
import 'package:image_fetcher/image_fetcher/presentation/bloc/image_fetcher_cubit.dart';
import 'package:image_fetcher/image_fetcher/presentation/widget/permission__handler_widget.dart';

class AlbumPage extends StatelessWidget {
  const AlbumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ImageFetcherCubit, ImageFetcherState>(
          listener: (context, state) {},
          builder: (context, state) {
            switch (state) {
              case ImageFetcherLoadingState():
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.buttonColor,
                  ),
                );
              case ImageFetcherInitial():
              case ImageFetcherPermissionPermanentlyDenied():
              case ImageFetcherPermissionDenied():
                return const PermissionHandlerWidget();
              case ImageFetcherPermissionGranted():
                return const Text("Permission Granted");

              default:
                return const PermissionHandlerWidget();
            }
          }),
    );
  }
}
