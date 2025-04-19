part of 'image_fetcher_cubit.dart';

sealed class ImageFetcherState extends Equatable {
  const ImageFetcherState();
}

final class ImageFetcherInitial extends ImageFetcherState {
  @override
  List<Object> get props => [];
}

final class ImageFetcherPermissionRequired extends ImageFetcherState {
  @override
  List<Object> get props => [];
}

final class ImageFetcherLoadingState extends ImageFetcherState {
  @override
  List<Object> get props => [];
}

final class ImageFetcherPermissionGranted extends ImageFetcherState {
  @override
  List<Object> get props => [];
}

final class ImageFetcherPermissionPermanentlyDenied extends ImageFetcherState {
  @override
  List<Object> get props => [];
}

final class ImageFetcherPermissionDenied extends ImageFetcherState {
  @override
  List<Object> get props => [];
}
