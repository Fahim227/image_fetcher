import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_fetcher/core/styles/colors.dart';
import 'package:image_fetcher/features/image_fetcher/presentation/bloc/image_fetcher_cubit.dart';

import 'core/dependencies/injectable.dart';
import 'features/image_fetcher/presentation/pages/album_page.dart';

void main() {
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Album app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.themeColor),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => getIt<ImageFetcherCubit>()..isPermissionGranted(),
        child: const AlbumPage(),
      ),
    );
  }
}
