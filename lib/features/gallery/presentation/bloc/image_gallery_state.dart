part of 'image_gallery_cubit.dart';

sealed class ImageGalleryState extends Equatable {
  const ImageGalleryState();
}

final class ImageGalleryInitial extends ImageGalleryState {
  @override
  List<Object> get props => [];
}

final class ImageGalleryLoading extends ImageGalleryState {
  @override
  List<Object> get props => [];
}

final class ImageGalleryLoaded extends ImageGalleryState {
  final List<String> imagePaths;
  final bool hasMore;

  const ImageGalleryLoaded(this.imagePaths, this.hasMore);

  @override
  List<Object> get props => [imagePaths, hasMore];
}
