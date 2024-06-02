import 'dart:convert';

import 'package:fitness_tracker_app/features/screens/workout/workout_record/workout_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WorkoutList extends StatelessWidget {
  const WorkoutList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => Get.to(() => const WorkoutWidget()),
            child: const Text('+'),
          ),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: get_workout(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Ошибка: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('Нет данных'));
              } else {
                print('in bilder');
                List<Map<String, dynamic>> workouts = snapshot.data!;
                return Expanded(
                    child: ListView.builder(
                  itemCount: workouts.length,
                  itemBuilder: (context, index) {
                    print('in itembilder');
                    print(workouts);
                    print(index);
                    print(workouts[index]);
                    final workout = workouts[index];
                    return ListTile(
                      title: Text('треня ёпта бля'),
                      subtitle: Text(
                        'Steps: ${workout['steps']}\n'
                        'Distance: ${workout['distance']}\n'
                        'Speed: ${workout['speed']}\n'
                        'Pace: ${workout['pace']}\n'
                        'Calories: ${workout['calories']}\n'
                        'Duration: ${workout['duration']}',
                      ),
                    );
                  },
                ));
              }
            },
          ),
        ],
      ),
    );
  }
}

Future<List<Map<String, dynamic>>> get_workout() async {
  final prefs = await SharedPreferences.getInstance();
  final String id = prefs.getString('user') ?? '';

  print(id);
  final query = {'id': id.replaceAll(RegExp(r'"'), '')};
  print(query);
  var url =
      Uri.https('utterly-comic-parakeet.ngrok-free.app', "workouts", query);
  print(url);
  var response = await http.get(url, headers: {
    "ngrok-skip-browser-warning": "true",
    "Content-Type": "application/json",
    "Accept": "application/json"
  });

  if (response.statusCode == 200) {
    final decodedBody = jsonDecode(response.body);

    if (decodedBody['success'] == false) {
      throw Exception('Failed to fetch workouts');
    }
    print(decodedBody['rows']);
    List<dynamic> data = decodedBody['rows'];
    return data.map((item) => item as Map<String, dynamic>).toList();
  } else {
    throw Exception('Failed to load workouts');
  }
}
