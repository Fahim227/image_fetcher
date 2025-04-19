import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_fetcher/core/services/permission/permission_service.dart';
part 'image_fetcher_state.dart';

@injectable
class ImageFetcherCubit extends Cubit<ImageFetcherState> {
  final PermissionService _permissionService;
  ImageFetcherCubit(this._permissionService) : super(ImageFetcherInitial());

  Future<void> isPermissionGranted() async {
    final isGranted = await _permissionService.isStoragePermissionGranted();
    log("isGranted === $isGranted");
    if (isGranted) {
      emit(ImageFetcherPermissionGranted());
    } else {
      emit(ImageFetcherPermissionRequired());
    }
  }

  Future<void> checkForPermission() async {
    emit(ImageFetcherLoadingState());

    final status = await _permissionService.requestStoragePermission();
    log("status === $status");
    if (status.isGranted) {
      emit(ImageFetcherPermissionGranted());
    } else if (status.isDenied) {
      final result = await Permission.storage.request();
      if (result.isGranted) {
        emit(ImageFetcherPermissionGranted());
      } else if (result.isPermanentlyDenied) {
        emit(ImageFetcherPermissionPermanentlyDenied());
      } else {
        emit(ImageFetcherPermissionDenied());
      }
    } else if (status.isPermanentlyDenied) {
      emit(ImageFetcherPermissionPermanentlyDenied());
    } else {
      emit(ImageFetcherPermissionDenied());
    }
  }
}
