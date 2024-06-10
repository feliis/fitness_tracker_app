import 'dart:async';
import 'dart:convert';

import 'package:fitness_tracker_app/features/screens/workout/workout_record/workout_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../navigation_menu.dart';
import '../../../../utils/const/colors.dart';

class WorkoutResultPage extends StatelessWidget {
  final String type_activity;
  final String timer;
  final int steps;
  final double distance;
  final double speed;
  final double pace;
  final int calories;
  final DateTime date_start;
  final DateTime date_stop;
  final List<Map<String, double>> locationHistory;

  const WorkoutResultPage({
    Key? key,
    required this.type_activity,
    required this.timer,
    required this.steps,
    required this.distance,
    required this.speed,
    required this.pace,
    required this.calories,
    required this.date_start,
    required this.date_stop,
    required this.locationHistory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: WorkoutResultStateful(
          type_activity: type_activity,
          timer: timer,
          steps: steps,
          distance: distance,
          speed: speed,
          pace: pace,
          calories: calories,
          date_start: date_start,
          date_stop: date_stop,
          locationHistory: locationHistory,
        ),
      ),
    );
  }
}

class WorkoutResultStateful extends StatefulWidget {
  final String type_activity;
  final String timer;
  final int steps;
  final double distance;
  final double speed;
  final double pace;
  final int calories;
  final DateTime date_start;
  final DateTime date_stop;
  final List<Map<String, double>> locationHistory;

  const WorkoutResultStateful({
    Key? key,
    required this.type_activity,
    required this.timer,
    required this.steps,
    required this.distance,
    required this.speed,
    required this.pace,
    required this.calories,
    required this.date_start,
    required this.date_stop,
    required this.locationHistory,
  }) : super(key: key);

  @override
  State<WorkoutResultStateful> createState() => _WorkoutResultState();
}

class _WorkoutResultState extends State<WorkoutResultStateful> {
  bool clicked = false;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            WorkoutDetail(
              timer: '${widget.timer}',
              steps: '${widget.steps}',
              distance: '${widget.distance}',
              speed: '${widget.speed}',
              pace: '${widget.pace}',
              calories: '${widget.calories}',
              date_start: '${widget.date_start}',
              date_stop: '${widget.date_stop}',
              locationHistory: widget.locationHistory,
            ),

            /// Button
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  child: ElevatedButton(
                    onPressed: !clicked
                        ? () => createWorkout(
                              widget.type_activity,
                              widget.steps,
                              widget.distance,
                              widget.speed,
                              widget.pace,
                              widget.calories,
                              widget.timer,
                              widget.date_start,
                              widget.date_stop,
                              widget.locationHistory,
                            )
                        : null,
                    style: ElevatedButton.styleFrom(
                      side: const BorderSide(color: Color.fromARGB(0, 0, 0, 0)),
                      backgroundColor: PColors.primary,
                    ),
                    child: const Text('Сохранить'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future createWorkout(type_activity, steps, distance, speed, pace, calories,
      timer, date_start, date_stop, coordinates) async {
    setState(() {
      clicked = true;
    });

    await Future.delayed(Duration(seconds: 1));
    final prefs = await SharedPreferences.getInstance();
    final String id = prefs.get('user').toString();
    print(id.toString());
    var url =
        Uri.https('utterly-comic-parakeet.ngrok-free.app', "create_workout");
    print(url);
    try {
      var response = await http.post(url,
          body: jsonEncode({
            'user_id': '${id.replaceAll(RegExp(r'"'), '')}',
            'type_activity': '${type_activity.replaceAll(RegExp(r'"'), '')}',
            'steps': steps.toString(),
            'distance': distance.toString(),
            'speed': speed.toString(),
            'pace': pace.toString(),
            'calories': calories.toString(),
            'duration': timer.toString(),
            'date_start': date_start.toString(),
            'date_stop': date_stop.toString(),
            'coordinates': coordinates,
          }),
          headers: {
            "ngrok-skip-browser-warning": "true",
            "Content-Type": "application/json",
            "Accept": "application/json"
          });
      print(response);
      Get.to(() => const NavigationMenu());
    } catch (e) {
      print(e);
      return '';
    }
  }
}
