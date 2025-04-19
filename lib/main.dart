import 'package:flutter/material.dart';
import 'package:image_fetcher/core/styles/colors.dart';

import 'image_fetcher/presentation/pages/album_page.dart';

void main() {
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
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.buttonColor),
        useMaterial3: true,
      ),
      home: const AlbumPage(),
    );
  }
}
