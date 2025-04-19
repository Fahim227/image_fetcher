import 'package:flutter/material.dart';

import '../widget/permission_page.dart';

class AlbumPage extends StatelessWidget {
  const AlbumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PermissionPage(),
    );
  }
}
