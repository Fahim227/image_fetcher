import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:image_fetcher/core/services/image_extractor/image_extractor_service.dart';
part 'image_gallery_state.dart';

@injectable
class ImageGalleryCubit extends Cubit<ImageGalleryState> {
  final IImageExtractorService iImageExtractorService;
  ImageGalleryCubit(this.iImageExtractorService) : super(ImageGalleryInitial());

  List<String> _allImages = [];
  final int _pageSize = 100;

  int _currentPage = 0;
  void fetchAllImages() async {
    emit(ImageGalleryLoading());
    _allImages = await iImageExtractorService.getImages();
    _currentPage = 0;
    final initialItems = _getPage(_currentPage);
    emit(ImageGalleryLoaded(initialItems));
  }

  void loadMoreImages() {
    if (state is ImageGalleryLoaded) {
      _currentPage++;
      final nextItems = _getPage(_currentPage);
      final currentImages =
          List<String>.from((state as ImageGalleryLoaded).imagePaths);

      emit(ImageGalleryLoaded([...currentImages, ...nextItems],
          hasMore: _hasMore()));
    }
  }

  bool _hasMore() {
    return (_currentPage + 1) * _pageSize < _allImages.length;
  }

  List<String> _getPage(int page) {
    final start = page * _pageSize;
    if (start >= _allImages.length) return [];

    final end = (_allImages.length < start + _pageSize)
        ? _allImages.length
        : start + _pageSize;
    return _allImages.sublist(start, end);
  }

  Future<void> saveAllImages(List<String> allImages) async {
    await iImageExtractorService.saveAllImages(allImages);
  }
}
