import 'dart:io';

import 'package:injectable/injectable.dart';

import '../repositories/file_repository.dart';

@injectable
class GetAllImages {
  final FileRepository _repository;

  GetAllImages(this._repository);

  Future<List<File>> call() async {
    return await _repository.fetchFilePath();
  }
}
