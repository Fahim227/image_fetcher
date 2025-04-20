// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../gallery/presentation/bloc/image_gallery_cubit.dart' as _i444;
import '../../image_fetcher/presentation/bloc/image_fetcher_cubit.dart'
    as _i853;
import '../services/image_extractor/image_extractor_impl.dart' as _i1034;
import '../services/image_extractor/image_extractor_service.dart' as _i373;
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
    gh.singleton<_i373.IImageExtractorService>(
        () => _i1034.ImageExtractorServiceImpl());
    gh.factory<_i444.ImageGalleryCubit>(
        () => _i444.ImageGalleryCubit(gh<_i373.IImageExtractorService>()));
    gh.factory<_i853.ImageFetcherCubit>(
        () => _i853.ImageFetcherCubit(gh<_i753.PermissionService>()));
    return this;
  }
}
