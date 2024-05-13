import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../../../../utils/const/sizes.dart';
import '../../profile/appbar.dart';
import '../pedometer.dart';

class CountUpTimerPage extends StatefulWidget {
  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => CountUpTimerPage(),
      ),
    );
  }

  @override
  _State createState() => _State();
}

class _State extends State<CountUpTimerPage> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  bool recordWorkout = false;
  String _status = '?';
  int _steps = 0, _stepsPrev = 0, _stepsNow = 0, calories = 0;
  double dist = 0.00, speed = 0.00;
  double averageRate = 0.00;

  final _isHours = true;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
    // onChange: (value) => print('onChange $value'),
    // onChangeRawSecond: (value) => print('onChangeRawSecond $value'),
    // onChangeRawMinute: (value) => print('onChangeRawMinute $value'),
    onStopped: () {
      print('onStop');
    },
    onEnded: () {
      print('onEnded');
    },
  );

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // _stopWatchTimer.rawTime.listen((value) =>
    //     print('rawTime $value ${StopWatchTimer.getDisplayTime(value)}'));
    // _stopWatchTimer.minuteTime.listen((value) => print('minuteTime $value'));
    // _stopWatchTimer.secondTime.listen((value) => print('secondTime $value'));
    // _stopWatchTimer.records.listen((value) => print('records $value'));
    // _stopWatchTimer.fetchStopped
    //     .listen((value) => print('stopped from stream'));
    // _stopWatchTimer.fetchEnded.listen((value) => print('ended from stream'));

    initPlatformState();

    /// Can be set preset time. This case is "00:01.23".
    // _stopWatchTimer.setPresetTime(mSec: 1234);
  }

  double roundDouble(double value, int places) {
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  void onStepCount(StepCount event) {
    print(event);
    setState(() {
      _steps = event.steps - _stepsPrev;
      dist = roundDouble((0.00072 * _steps), 2);
    });
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 0;
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    print(_status);
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  void onStart() {
    recordWorkout = true;
    _stopWatchTimer.onStartTimer();
    _stepsPrev = _steps;
    print(_stepsPrev);
  }

  void onStop() {
    recordWorkout = false;
    _stopWatchTimer.onStopTimer();
    _stepsPrev = 0;
    _stepsNow = _steps;
    print(_stepsNow);
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PAppBar(
        showBackArrow: true,
        title: Text('Тренировка'),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 32,
              horizontal: 16,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                /// Display stop watch time
                StreamBuilder<int>(
                  stream: _stopWatchTimer.rawTime,
                  initialData: _stopWatchTimer.rawTime.value,
                  builder: (context, snap) {
                    final value = snap.data!;
                    final time =
                        StopWatchTimer.getDisplayTime(value, hours: _isHours);
                    return Column(
                      children: <Widget>[
                        Text(
                          'Время',
                          style: TextStyle(fontSize: 18),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            time,
                            style: const TextStyle(
                                fontSize: 38,
                                fontFamily: 'Helvetica',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: PSizes.spaceBtwInputFields * 2),

                /// Distance & Steps
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Расстояние',
                          style: TextStyle(fontSize: 18),
                        ),
                        Row(
                          children: [
                            Text(
                              recordWorkout ? '$dist' : '0.00',
                              style: const TextStyle(
                                  fontSize: 38,
                                  fontFamily: 'Helvetica',
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: PSizes.spaceBtwInputFields),
                            Text(
                              'км',
                              style: const TextStyle(
                                  fontSize: 22,
                                  fontFamily: 'Helvetica',
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(width: PSizes.spaceBtwInputFields * 4),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Шаги',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          recordWorkout ? '$_steps' : '0',
                          style: const TextStyle(
                              fontSize: 38,
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: PSizes.spaceBtwInputFields * 2),

                /// Speed and Average rate
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Скорость',
                          style: TextStyle(fontSize: 18),
                        ),
                        Row(
                          children: [
                            Text(
                              recordWorkout ? '$speed' : '--',
                              style: const TextStyle(
                                  fontSize: 38,
                                  fontFamily: 'Helvetica',
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: PSizes.spaceBtwInputFields),
                            Text(
                              'км/ч',
                              style: const TextStyle(
                                  fontSize: 22,
                                  fontFamily: 'Helvetica',
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(width: PSizes.spaceBtwInputFields * 4),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Темп',
                          style: TextStyle(fontSize: 18),
                        ),
                        Row(
                          children: [
                            Text(
                              recordWorkout ? '$averageRate' : '--',
                              style: const TextStyle(
                                  fontSize: 38,
                                  fontFamily: 'Helvetica',
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: PSizes.spaceBtwInputFields),
                            Text(
                              '/км',
                              style: const TextStyle(
                                  fontSize: 22,
                                  fontFamily: 'Helvetica',
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: PSizes.spaceBtwInputFields * 2),

                /// Calories
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Калории',
                      style: TextStyle(fontSize: 18),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          recordWorkout ? '$calories' : '0',
                          style: const TextStyle(
                              fontSize: 38,
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: PSizes.spaceBtwInputFields),
                        Text(
                          'ккал',
                          style: const TextStyle(
                              fontSize: 22,
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: PSizes.spaceBtwSections),

                /// Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: FilledButton(
                          onPressed: onStart,
                          child: const Text(
                            'Start',
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: FilledButton(
                          onPressed: onStop,
                          child: const Text(
                            'Stop',
                          ),
                        ),
                      ),
                    ),
                    // Flexible(
                    //   child: Padding(
                    //     padding: const EdgeInsets.symmetric(horizontal: 4),
                    //     child: FilledButton(
                    //       onPressed: _stopWatchTimer.onResetTimer,
                    //       child: const Text(
                    //         'Reset',
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
