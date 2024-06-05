import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../../../common/widgets/appbar.dart';
import '../../../../utils/const/colors.dart';
import '../../../../utils/const/sizes.dart';
import 'workoutres_page.dart';

class WorkoutWidget extends StatefulWidget {
  const WorkoutWidget({Key? key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<WorkoutWidget> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  bool recordWorkout = false;
  String _status = '?';
  int _steps = 0,
      _stepsPrev = 0,
      _stepsNow = 0,
      calories = 0,
      milisecond = 0,
      time = 0;
  double dist = 0.00, speed = 0.00, weight = 68.5, height = 170.0, pace = 0.00;
  late DateTime date_start, date_stop;
  String buttonText = 'Начать';
  Color buttonColor = PColors.primary;

  final _isHours = true;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
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
    initPlatformState();
  }

  double roundDouble(double value, int places) {
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  void onStepCount(StepCount event) {
    _stopWatchTimer.rawTime.listen((value) => setSpeed(value.toInt()));
    setState(() {
      _steps = event.steps - _stepsPrev;
      dist = roundDouble((0.00072 * _steps), 2);
    });
  }

  void setSpeed(int time) {
    setState(() {
      double minutes = (time / 60000);
      double s = (dist / (minutes / 60));
      speed = double.parse(s.toStringAsFixed(2));
      double p = 60 / speed;

      // int paceSeconds =
      //     ((double.parse(p.toStringAsFixed(2)) - p.floor()) * 60).toInt();
      // int paceMinutes = p.toInt();
      pace = p;

      double c = (0.035 * weight + (speed / height) * 0.029 * weight) * minutes;
      calories = c.toInt();
      if (speed == double.infinity || pace == double.infinity) {
        speed = 0.00;
        pace = 0.00;
        // "0'00" + '"';
      }
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

  String formatTime(int totalMilliseconds) {
    int hours = totalMilliseconds ~/ 3600000;
    int minutes = (totalMilliseconds % 3600000) ~/ 60000;
    int seconds = (totalMilliseconds % 60000) ~/ 1000;
    int milliseconds = totalMilliseconds % 1000;

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String threeDigits(int n) => n.toString().padLeft(3, '0');

    String formattedTime =
        '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
    return formattedTime;
  }

  void onStart() {
    setState(
      () {
        date_start = DateTime.now();
        recordWorkout = true;
        _stopWatchTimer.onStartTimer();
        _stepsPrev = _steps;
        _steps -= _stepsPrev;
        dist = 0.00;
        speed = 0.00;
        pace = 0.00;
        calories = 0;
        if (buttonText == "Начать") {
          buttonText = "Завершить";
          buttonColor = PColors.error;
        } else {
          buttonText = "Начать";
          buttonColor = PColors.primary;
        }
      },
    );
  }

  void onStop() {
    date_stop = DateTime.now();
    recordWorkout = false;
    _stopWatchTimer.onStopTimer();
    _stepsPrev = 0;
    _stepsNow = _steps;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutResultPage(
            timer: formatTime(_stopWatchTimer.rawTime.value),
            steps: _stepsNow,
            distance: dist,
            speed: speed,
            pace: pace,
            calories: calories,
            date_start: date_start,
            date_stop: date_stop,),
      ),
    );
    print('temp: $pace');
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
        showBackArrow: false,
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
                const SizedBox(height: PSizes.spaceBtwSections),

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
                                fontSize: 28,
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
                              recordWorkout ? '$dist' : '0.0',
                              style: const TextStyle(
                                  fontSize: 28,
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
                    const SizedBox(width: PSizes.spaceBtwInputFields * 3),
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
                              fontSize: 28,
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: PSizes.spaceBtwInputFields * 2),

                /// Speed and pace
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
                                  fontSize: 28,
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
                    const SizedBox(width: PSizes.spaceBtwInputFields * 3),
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
                              recordWorkout ? '$pace' : '--',
                              style: const TextStyle(
                                  fontSize: 28,
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
                              fontSize: 28,
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

                const SizedBox(height: PSizes.spaceBtwSections * 3),

                /// Button

                SizedBox(
                  width: 250,
                  child: ElevatedButton(
                    onPressed: recordWorkout ? onStop : onStart,
                    child: Text(buttonText),
                    style: ElevatedButton.styleFrom(
                      side: const BorderSide(color: Color.fromARGB(0, 0, 0, 0)),
                      backgroundColor: buttonColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
