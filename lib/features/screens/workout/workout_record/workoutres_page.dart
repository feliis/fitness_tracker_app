import 'package:fitness_tracker_app/common/widgets/curved_edges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/circular_container.dart';
import '../../../../navigation_menu.dart';
import '../../../../utils/const/colors.dart';
import '../../../../utils/const/sizes.dart';

class WorkoutResultPage extends StatelessWidget {
  final String timer;
  final int steps;
  final double distance;
  final double speed;
  final String pace;
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
                                pace,
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
                          onPressed: () => Get.to(() => const NavigationMenu()),
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


  // child: Padding(
  //           padding: const EdgeInsets.symmetric(
  //             vertical: 32,
  //             horizontal: 16,
  //           ),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: <Widget>[
  //               const SizedBox(height: PSizes.spaceBtwSections),

  //               /// Timer
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Text(
  //                     timer,
  //                     style: const TextStyle(
  //                         fontSize: 28,
  //                         fontFamily: 'Helvetica',
  //                         fontWeight: FontWeight.bold),
  //                   ),
  //                 ],
  //               ),

  //               const SizedBox(height: PSizes.spaceBtwInputFields * 2),

  //               /// Distance & Steps
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: <Widget>[
  //                       Text(
  //                         'Расстояние',
  //                         style: TextStyle(fontSize: 18),
  //                       ),
  //                       Row(
  //                         children: [
  //                           Text(
  //                             '$distance',
  //                             style: const TextStyle(
  //                                 fontSize: 28,
  //                                 fontFamily: 'Helvetica',
  //                                 fontWeight: FontWeight.bold),
  //                           ),
  //                           const SizedBox(width: PSizes.spaceBtwInputFields),
  //                           Text(
  //                             'км',
  //                             style: const TextStyle(
  //                                 fontSize: 22,
  //                                 fontFamily: 'Helvetica',
  //                                 fontWeight: FontWeight.normal),
  //                           ),
  //                         ],
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(width: PSizes.spaceBtwInputFields * 3),
  //                   Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: <Widget>[
  //                       Text(
  //                         'Шаги',
  //                         style: TextStyle(fontSize: 18),
  //                       ),
  //                       Text(
  //                         '$steps',
  //                         style: const TextStyle(
  //                             fontSize: 28,
  //                             fontFamily: 'Helvetica',
  //                             fontWeight: FontWeight.bold),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),

  //               const SizedBox(height: PSizes.spaceBtwInputFields * 2),

  //               /// Speed and pace
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Text(
  //                         'Скорость',
  //                         style: TextStyle(fontSize: 18),
  //                       ),
  //                       Row(
  //                         children: [
  //                           Text(
  //                             '$speed',
  //                             style: const TextStyle(
  //                                 fontSize: 28,
  //                                 fontFamily: 'Helvetica',
  //                                 fontWeight: FontWeight.bold),
  //                           ),
  //                           const SizedBox(width: PSizes.spaceBtwInputFields),
  //                           Text(
  //                             'км/ч',
  //                             style: const TextStyle(
  //                                 fontSize: 22,
  //                                 fontFamily: 'Helvetica',
  //                                 fontWeight: FontWeight.normal),
  //                           ),
  //                         ],
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(width: PSizes.spaceBtwInputFields * 3),
  //                   Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Text(
  //                         'Темп',
  //                         style: TextStyle(fontSize: 18),
  //                       ),
  //                       Row(
  //                         children: [
  //                           Text(
  //                             pace,
  //                             style: const TextStyle(
  //                                 fontSize: 28,
  //                                 fontFamily: 'Helvetica',
  //                                 fontWeight: FontWeight.bold),
  //                           ),
  //                           const SizedBox(width: PSizes.spaceBtwInputFields),
  //                           Text(
  //                             '/км',
  //                             style: const TextStyle(
  //                                 fontSize: 22,
  //                                 fontFamily: 'Helvetica',
  //                                 fontWeight: FontWeight.normal),
  //                           ),
  //                         ],
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),

  //               const SizedBox(height: PSizes.spaceBtwInputFields * 2),

  //               /// Calories
  //               Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Text(
  //                     'Калории',
  //                     style: TextStyle(fontSize: 18),
  //                   ),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Text(
  //                         '$calories',
  //                         style: const TextStyle(
  //                             fontSize: 28,
  //                             fontFamily: 'Helvetica',
  //                             fontWeight: FontWeight.bold),
  //                       ),
  //                       const SizedBox(width: PSizes.spaceBtwInputFields),
  //                       Text(
  //                         'ккал',
  //                         style: const TextStyle(
  //                             fontSize: 22,
  //                             fontFamily: 'Helvetica',
  //                             fontWeight: FontWeight.normal),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),

  //               const SizedBox(height: PSizes.spaceBtwSections * 3),

  //               /// Button

  //               SizedBox(
  //                 width: 250,
  //                 child: ElevatedButton(
  //                   onPressed: () {},
  //                   child: const Text('Завершено'),
  //                   style: ElevatedButton.styleFrom(
  //                     side: const BorderSide(color: Color.fromARGB(0, 0, 0, 0)),
  //                     backgroundColor: PColors.error,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
        