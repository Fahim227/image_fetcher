// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/gallery/data/datasources/platform_data_source.dart'
    as _i615;
import '../../features/gallery/data/datasources/platform_data_source_impl.dart'
    as _i529;
import '../../features/gallery/data/repositories/file_repository_impl.dart'
    as _i750;
import '../../features/gallery/domain/repositories/file_repository.dart'
    as _i944;
import '../../features/gallery/domain/use_case/get_all_images.dart' as _i280;
import '../../features/gallery/domain/use_case/save_all_images.dart' as _i131;
import '../../features/gallery/presentation/bloc/image_gallery_cubit.dart'
    as _i827;
import '../../features/image_fetcher/presentation/bloc/image_fetcher_cubit.dart'
    as _i261;
import '../services/permission/permission_service.dart' as _i753;
import '../services/permission/permission_service_impl.dart' as _i1018;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i753.PermissionService>(
        () => _i1018.PermissionServiceImpl());
    gh.factory<_i615.PlatformDataSource>(() => _i529.PlatformDataSourceImpl());
    gh.factory<_i261.ImageFetcherCubit>(
        () => _i261.ImageFetcherCubit(gh<_i753.PermissionService>()));
    gh.factory<_i944.FileRepository>(
        () => _i750.FileRepositoryImpl(gh<_i615.PlatformDataSource>()));
    gh.factory<_i280.GetAllImages>(
        () => _i280.GetAllImages(gh<_i944.FileRepository>()));
    gh.factory<_i131.SaveAllImages>(
        () => _i131.SaveAllImages(gh<_i944.FileRepository>()));
    gh.factory<_i827.ImageGalleryCubit>(() => _i827.ImageGalleryCubit(
          gh<_i280.GetAllImages>(),
          gh<_i131.SaveAllImages>(),
        ));
    return this;
  }
}
