import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_fetcher/features/gallery/domain/use_case/get_all_images.dart';
import 'package:image_fetcher/features/gallery/domain/use_case/save_all_images.dart';
import 'package:injectable/injectable.dart';
part 'image_gallery_state.dart';

@injectable
class ImageGalleryCubit extends Cubit<ImageGalleryState> {
  final GetAllImages _getAllImages;
  final SaveAllImages _saveAllImages;
  ImageGalleryCubit(this._getAllImages, this._saveAllImages)
      : super(ImageGalleryInitial());

  List<File> _allImages = [];
  final int _pageSize = 50;

  int _currentPage = 0;
  void fetchAllImages() async {
    emit(ImageGalleryLoading());
    _allImages = await _getAllImages.call();
    final initialItems = _getPage(_currentPage);
    emit(ImageGalleryLoaded(initialItems, _hasMore()));
  }

  void loadMoreImages() {
    if (state is ImageGalleryLoaded && (state as ImageGalleryLoaded).hasMore) {
      _currentPage++;
      final nextItems = _getPage(_currentPage);
      final currentImages = (state as ImageGalleryLoaded).allImages;
      emit(ImageGalleryLoaded([...currentImages, ...nextItems], _hasMore()));
    }
  }

  bool _hasMore() {
    return (_currentPage + 1) * _pageSize < _allImages.length;
  }

  List<File> _getPage(int page) {
    final start = page * _pageSize;
    if (start >= _allImages.length) return [];

    final end = (_allImages.length < start + _pageSize)
        ? _allImages.length
        : start + _pageSize;
    return _allImages.sublist(start, end);
  }

  Future<void> saveAllImages(List<String> allImages) async {
    await _saveAllImages.call(allImages);
  }
}
