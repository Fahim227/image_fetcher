import 'dart:io';
import 'dart:typed_data';

import 'package:injectable/injectable.dart';

import '../../domain/repositories/file_repository.dart';
import '../datasources/platform_data_source.dart';

@Injectable(as: FileRepository)
class FileRepositoryImpl implements FileRepository {
  final PlatformDataSource _platformDataSource;

  FileRepositoryImpl(this._platformDataSource);

  @override
  Future<List<File>> fetchFilePath() async {
    final listOfImagePaths = await _platformDataSource.getImages();
    return List<File>.from(listOfImagePaths.map((e) => File(e)));
  }

  @override
  Future<String> saveAllFiles(List<File> images) async {
    List<Uint8List> imagesInBytes = await getImagesInBytes(images);
    return await _platformDataSource.saveAllImages(imagesInBytes);
  }

  Future<List<Uint8List>> getImagesInBytes(List<File> images) async {
    return await Future.wait(images.map((e) => e.readAsBytes()));
  }
}
