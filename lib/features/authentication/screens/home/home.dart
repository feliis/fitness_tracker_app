import 'package:flutter/material.dart';

import '../home/timer/timer_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: TimerPage(),
      ),
    );
  }
}
