import 'package:flutter/material.dart';

import '../../../common/widgets/appbar.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PAppBar(
        showBackArrow: false,
        title: Text('Главная страница'),
      ),
      body: Center(),
    );
  }
}
