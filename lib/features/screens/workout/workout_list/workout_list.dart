import 'package:fitness_tracker_app/features/screens/workout/workout_record/workout_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkoutList extends StatelessWidget {
  const WorkoutList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => Get.to(() => const WorkoutWidget()),
              child: const Text('+'),
            )
          ],
        ),
      ),
    );
  }
}
