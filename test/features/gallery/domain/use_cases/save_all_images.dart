import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:image_fetcher/features/gallery/domain/use_case/save_all_images.dart';
import 'package:mockito/mockito.dart';

import '../../data/file_repository.mock.mocks.dart';

void main() {
  late SaveAllImages useCase;
  late MockFileRepository mockRepository;

  setUp(() {
    mockRepository = MockFileRepository();
    useCase = SaveAllImages(mockRepository);
  });

  test('should save files and return success message as string', () async {
    final testFiles = [
      File('path/to/image1.jpg'),
      File('path/to/image2.jpg'),
    ];
    const String successMessage = "Done";
    when(mockRepository.saveAllFiles(testFiles))
        .thenAnswer((_) async => successMessage);

    // act
    final result = await useCase(testFiles);

    // assert
    expect(result, successMessage);
    verify(mockRepository.saveAllFiles(testFiles)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return success message even when saving an empty list of files',
      () async {
    final testFiles = <File>[];
    const String successMessage = "Done";

    when(mockRepository.saveAllFiles(testFiles))
        .thenAnswer((_) async => successMessage);

    final result = await useCase(testFiles);

    expect(result, successMessage);
    verify(mockRepository.saveAllFiles(testFiles)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should throw an exception when repository fails to save files',
      () async {
    final testFiles = [
      File('path/to/image1.jpg'),
      File('path/to/image2.jpg'),
    ];
    final exception = Exception("Failed to save files");

    when(mockRepository.saveAllFiles(testFiles)).thenThrow(exception);

    expect(() => useCase(testFiles), throwsA(isA<Exception>()));
    verify(mockRepository.saveAllFiles(testFiles)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
