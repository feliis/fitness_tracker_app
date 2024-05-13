import 'package:flutter/material.dart';

import 'count_up_timer_page.dart';

class TimerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FilledButton(
                onPressed: () {
                  CountUpTimerPage.navigatorPush(context);
                },
                child: const Text('Секундомер'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
