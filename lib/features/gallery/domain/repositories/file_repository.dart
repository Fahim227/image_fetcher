import 'dart:io';

abstract class FileRepository {
  Future<List<File>> fetchFilePath();
  Future<String> saveAllFiles(List<File> images);
}
