import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_fetcher/features/gallery/presentation/bloc/image_gallery_cubit.dart';
import 'package:mockito/mockito.dart';

import '../../domain/use_cases/mock_use_cases/use_cases.mocks.dart';

void main() {
  late ImageGalleryCubit cubit;
  late MockGetAllImages mockGetAllImages;
  late MockSaveAllImages mockSaveAllImages;

  setUp(() {
    mockGetAllImages = MockGetAllImages();
    mockSaveAllImages = MockSaveAllImages();
    cubit = ImageGalleryCubit(mockGetAllImages, mockSaveAllImages);
  });

  group('ImageGalleryCubit', () {
    final List<File> testFiles = List.generate(
      120,
      (index) => File('path/to/image_$index.jpg'),
    );

    test('initial state is ImageGalleryInitial', () {
      expect(cubit.state, ImageGalleryInitial());
    });

    blocTest<ImageGalleryCubit, ImageGalleryState>(
      'emits [Loading, Loaded] with paginated data when fetchAllImages is called',
      build: () {
        when(mockGetAllImages.call()).thenAnswer((_) async => testFiles);
        return cubit;
      },
      act: (cubit) => cubit.fetchAllImages(),
      expect: () => [
        ImageGalleryLoading(),
        isA<ImageGalleryLoaded>()
            .having(
              (state) => state.allImages.length,
              'initial page size',
              50,
            )
            .having(
              (state) => state.hasMore,
              'has more pages',
              true,
            )
      ],
      verify: (_) {
        verify(mockGetAllImages.call()).called(1);
      },
    );

    blocTest<ImageGalleryCubit, ImageGalleryState>(
      'emits next page of images when loadMoreImages is called',
      build: () {
        when(mockGetAllImages.call()).thenAnswer((_) async => testFiles);
        return cubit;
      },
      act: (cubit) async {
        await cubit.fetchAllImages();
        cubit.loadMoreImages();
      },
      expect: () => [
        ImageGalleryLoading(),
        predicate<ImageGalleryLoaded>((state) {
          return state.allImages.length == 50 && state.hasMore == true;
        }, 'Loaded with 50 images and hasMore true'),
        predicate<ImageGalleryLoaded>((state) {
          return state.allImages.length == 100 && state.hasMore == true;
        }, 'Loaded with 100 images and hasMore true'),
      ],
    );

    blocTest<ImageGalleryCubit, ImageGalleryState>(
      'calls saveAllImages use case correctly',
      build: () {
        when(mockSaveAllImages.call(testFiles)).thenAnswer((_) async => "Done");
        return cubit;
      },
      act: (cubit) => cubit.saveAllImages(testFiles),
      verify: (_) {
        verify(mockSaveAllImages.call(testFiles)).called(1);
      },
    );
  });
}
