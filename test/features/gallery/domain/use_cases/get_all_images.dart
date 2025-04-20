import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:image_fetcher/features/gallery/domain/use_case/get_all_images.dart';
import 'package:mockito/mockito.dart';

import '../../data/file_repository.mock.mocks.dart';

void main() {
  late GetAllImages useCase;
  late MockFileRepository mockRepository;

  setUp(() {
    mockRepository = MockFileRepository();
    useCase = GetAllImages(mockRepository);
  });

  test('should return file from repository', () async {
    final testFiles = [
      File('path/to/image1.jpg'),
      File('path/to/image2.jpg'),
    ];
    when(mockRepository.fetchFilePath()).thenAnswer((_) async => testFiles);

    // act
    final result = await useCase();

    // assert
    expect(result, testFiles);
    verify(mockRepository.fetchFilePath()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
