import 'dart:convert';

import 'package:fitness_tracker_app/common/widgets/curved_edges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common/widgets/circular_container.dart';
import '../../../../navigation_menu.dart';
import '../../../../utils/const/colors.dart';
import '../../../../utils/const/sizes.dart';
import '../../../../utils/helper_functions.dart';

class WorkoutResultPage extends StatelessWidget {
  final String timer;
  final int steps;
  final double distance;
  final double speed;
  final double pace;
  final int calories;

  const WorkoutResultPage({
    Key? key,
    required this.timer,
    required this.steps,
    required this.distance,
    required this.speed,
    required this.pace,
    required this.calories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: CustomCurvedEdges(),
              child: Container(
                color: PColors.primary,
                padding: const EdgeInsets.all(0),
                child: SizedBox(
                  height: 150,
                  child: Stack(
                    children: [
                      // Positioned(
                      //   top: 85,
                      //   right: 350,
                      //   child: IconButton(
                      //       color: PColors.white,
                      //       onPressed: () =>
                      //           Get.to(() => const NavigationMenu()),
                      //       icon: const Icon(Iconsax.arrow_left)),
                      // ),
                      Positioned(
                        top: 85,
                        left: 25,
                        child: Row(
                          children: [
                            Text(
                              '$distance',
                              style: const TextStyle(
                                  fontSize: 32,
                                  color: PColors.white,
                                  fontFamily: 'Helvetica',
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: PSizes.spaceBtwInputFields),
                            const Text(
                              'км',
                              style: TextStyle(
                                  fontSize: 32,
                                  color: PColors.white,
                                  fontFamily: 'Helvetica',
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: -150,
                        right: -250,
                        child: CircularContainer(
                            backgroundColor:
                                PColors.textWhite.withOpacity(0.1)),
                      ),
                      Positioned(
                        top: 100,
                        right: -300,
                        child: CircularContainer(
                            backgroundColor:
                                PColors.textWhite.withOpacity(0.1)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: PSizes.spaceBtwInputFields),

                  const Row(
                    children: [
                      Text(
                        'Сведения о тренировке',
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Helvetica',
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  const SizedBox(height: PSizes.spaceBtwInputFields),

                  /// Timer
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Время тренировки',
                        style: TextStyle(
                            fontSize: 16,
                            color: PColors.darkGrey,
                            fontFamily: 'Helvetica',
                            fontWeight: FontWeight.normal),
                      ),
                      Text(
                        timer,
                        style: const TextStyle(
                            fontSize: 22,
                            fontFamily: 'Helvetica',
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  const SizedBox(height: PSizes.spaceBtwItems),

                  /// Distance & Steps
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'Расстояние',
                            style: TextStyle(
                                fontSize: 16, color: PColors.darkGrey),
                          ),
                          Row(
                            children: [
                              Text(
                                '$distance',
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontFamily: 'Helvetica',
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                  width: PSizes.spaceBtwInputFields / 2),
                              const Text(
                                'км',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontFamily: 'Helvetica',
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(width: PSizes.spaceBtwInputFields * 3),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'Шаги',
                            style: TextStyle(
                              fontSize: 16,
                              color: PColors.darkGrey,
                            ),
                          ),
                          Text(
                            '$steps',
                            style: const TextStyle(
                                fontSize: 22,
                                fontFamily: 'Helvetica',
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: PSizes.spaceBtwItems),

                  /// Speed and pace
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ср. скорость',
                            style: TextStyle(
                              fontSize: 16,
                              color: PColors.darkGrey,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                '$speed',
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontFamily: 'Helvetica',
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                  width: PSizes.spaceBtwInputFields / 2),
                              const Text(
                                'км/ч',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontFamily: 'Helvetica',
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(width: PSizes.spaceBtwInputFields * 3),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ср. темп',
                            style: TextStyle(
                              fontSize: 16,
                              color: PColors.darkGrey,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                PHelperFunctions.getPace(pace),
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontFamily: 'Helvetica',
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                  width: PSizes.spaceBtwInputFields / 2),
                              const Text(
                                '/км',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontFamily: 'Helvetica',
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: PSizes.spaceBtwItems),

                  /// Calories
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Калории тренировки',
                        style: TextStyle(fontSize: 16, color: PColors.darkGrey),
                      ),
                      Row(
                        children: [
                          Text(
                            '$calories',
                            style: const TextStyle(
                                fontSize: 22,
                                fontFamily: 'Helvetica',
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: PSizes.spaceBtwInputFields / 2),
                          const Text(
                            'ккал',
                            style: TextStyle(
                                fontSize: 22,
                                fontFamily: 'Helvetica',
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: PSizes.spaceBtwSections * 4.5),

                  /// Button
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 250,
                        child: ElevatedButton(
                          onPressed: () => createWorkout(
                              steps, distance, speed, pace, calories, timer),
                          style: ElevatedButton.styleFrom(
                            side: const BorderSide(
                                color: Color.fromARGB(0, 0, 0, 0)),
                            backgroundColor: PColors.primary,
                          ),
                          child: const Text('Сохранить'),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future createWorkout(
    steps, distance, speed, pace, calories, timer) async {
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
          'steps': steps.toString(),
          'distance': distance.toString(),
          'speed': speed.toString(),
          'pace': pace.toString(),
          'calories': calories.toString(),
          'duration': timer.toString(),
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
