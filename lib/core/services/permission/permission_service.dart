import 'package:permission_handler/permission_handler.dart';

abstract class PermissionService {
  Future<bool> isStoragePermissionGranted();
  Future<PermissionStatus> requestStoragePermission();
}
