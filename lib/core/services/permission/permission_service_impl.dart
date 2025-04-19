import 'package:image_fetcher/core/services/permission/permission_service.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

@LazySingleton(as: PermissionService)
class PermissionServiceImpl implements PermissionService {
  @override
  Future<bool> isStoragePermissionGranted() async {
    return await Permission.storage.isGranted;
  }

  @override
  Future<PermissionStatus> requestStoragePermission() async {
    return await Permission.storage.request();
  }
}
