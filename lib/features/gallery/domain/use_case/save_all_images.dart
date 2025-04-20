import 'package:injectable/injectable.dart';

import '../repositories/file_repository.dart';

@injectable
class SaveAllImages {
  final FileRepository _repository;

  SaveAllImages(this._repository);

  Future<String> call(List<String> images) async {
    return await _repository.saveAllFiles(images);
  }
}
