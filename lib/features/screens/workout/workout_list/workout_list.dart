import 'dart:convert';

import 'package:fitness_tracker_app/features/screens/workout/workout_record/workout_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/const/colors.dart';
import '../../../../utils/const/sizes.dart';

class WorkoutList extends StatelessWidget {
  const WorkoutList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center (
        child: Padding(
          padding: const EdgeInsets.all(PSizes.defaultSpace),
          child: Column(
        children: [
          ElevatedButton(
            onPressed: () => Get.to(() => const WorkoutWidget()),
            child: const Text('+'),
          ),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: get_workouts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Ошибка: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('Нет данных'));
              } else {
                List<Map<String, dynamic>> workouts = snapshot.data!;
                
                return Expanded(
                    child: ListView.builder(
                  itemCount: workouts.length,
                  itemBuilder: (context, index) {
                    final workout = workouts[index];
                    String start = '${workout['date_start']}';
                    DateTime dateTime = DateTime.parse(start);
                    String dateStart = DateFormat('HH:mm').format(dateTime);


                    return Column(
                      children: [
                    InkWell(
                      onTap: () => get_workout_info('${workout['id']}'),
                      child: Container(
                        decoration: BoxDecoration(
                          color: PColors.lightGrey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        
                        width: double.infinity,
                        height: 85,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(PSizes.md, PSizes.md, PSizes.md, PSizes.md),
                          child:  Row(children: [
                              /// Иконка 
                              const Icon(Icons.directions_walk,
                              size: 30),
                              const SizedBox(width: PSizes.spaceBtwItems),
                              Column(
                                children: [
                                  /// Тип тренировки
                                  const Text(
                                  'Ходьба',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.normal),
                                  ),
                                  const SizedBox(height: PSizes.spaceBtwItems/2),
                                  /// Дистанция
                                  Row(children: [
                                    Text(
                                    '${workout['distance']}',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Helvetica',
                                        fontWeight: FontWeight.bold),
                                    ),
                                  
                                
                                  const SizedBox(width: PSizes.spaceBtwItems/3),
                                  const Text(
                                    'км',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Helvetica',
                                        fontWeight: FontWeight.normal),
                                  ),
                                ])
                                ],
                              ),
                               const Spacer(),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                  '${workout['duration']}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.normal),
                                  ),
                                  const SizedBox(height: PSizes.spaceBtwItems/2),
                                  Text(
                                  dateStart,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.normal),
                                  ),
                                ]),
                                ],
                              ),
                        ),
                        
                      ),
                    ),
                    const SizedBox(height: PSizes.spaceBtwInputFields),
                    ]);         
                  },
                 ),
                 );
            }},
            
          ),


        ],
      ),
      ),
    ),
    );
  }

Future<List<Map<String, dynamic>>> get_workouts() async {
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

  Future<Map<String, dynamic>> get_workout_info(id) async {
  print(id);
  final query = {'id': id.replaceAll(RegExp(r'"'), '')};
  print(query);
  var url =
      Uri.https('utterly-comic-parakeet.ngrok-free.app', "workout", query);
  print(url);
  try {
    var response = await http.get(url, headers: {
      "ngrok-skip-browser-warning": "true",
      "Content-Type": "application/json",
      "Accept": "application/json"
    });
    print(response);
    var decodedBody = jsonDecode(response.body);
    if (decodedBody['success'] == false) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  } catch (e) {
    print(e);
    throw Error();
  }
}
}
