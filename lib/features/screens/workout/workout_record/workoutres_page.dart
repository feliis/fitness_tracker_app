import 'dart:async';
import 'dart:convert';
import 'package:fitness_tracker_app/common/widgets/map/presentation/screens/map_route.dart';
import 'package:fitness_tracker_app/features/screens/workout/workout_record/workout_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import '../../../../common/widgets/curved_edges.dart';
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
  final DateTime date_start;
  final DateTime date_stop;
  final List<Map<String, double>> locationHistory;
  final PlacemarkMapObject? userLocationMarker;
  final PlacemarkMapObject? startMarker;
  final PlacemarkMapObject? endMarker;

  const WorkoutResultPage({
    Key? key,
    required this.timer,
    required this.steps,
    required this.distance,
    required this.speed,
    required this.pace,
    required this.calories,
    required this.date_start,
    required this.date_stop,
    required this.locationHistory,
    required this.userLocationMarker,
    required this.startMarker,
    required this.endMarker,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: WorkoutResultStateful(
          timer: timer,
          steps: steps,
          distance: distance,
          speed: speed,
          pace: pace,
          calories: calories,
          date_start: date_start,
          date_stop: date_stop,
          locationHistory: locationHistory,
          userLocationMarker: userLocationMarker,
          startMarker: startMarker,
          endMarker: endMarker,
        ),
      ),
    );
  }
}

class WorkoutResultStateful extends StatefulWidget {
  final String timer;
  final int steps;
  final double distance;
  final double speed;
  final double pace;
  final int calories;
  final DateTime date_start;
  final DateTime date_stop;
  final List<Map<String, double>> locationHistory;
  final PlacemarkMapObject? userLocationMarker;
  final PlacemarkMapObject? startMarker;
  final PlacemarkMapObject? endMarker;

  const WorkoutResultStateful({
    Key? key,
    required this.timer,
    required this.steps,
    required this.distance,
    required this.speed,
    required this.pace,
    required this.calories,
    required this.date_start,
    required this.date_stop,
    required this.locationHistory,
    required this.userLocationMarker,
    required this.startMarker,
    required this.endMarker,
  }) : super(key: key);

  @override
  State<WorkoutResultStateful> createState() => _WorkoutResultState();
}

class _WorkoutResultState extends State<WorkoutResultStateful> {
  bool clicked = false;

  @override
  initState() {
    super.initState();
    updateRoutePolyline();
  }

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
                              '${widget.distance}',
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
                padding: const EdgeInsets.symmetric(horizontal: 25),
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
                          widget.timer,
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
                                  '${widget.distance}',
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
                              '${widget.steps}',
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
                                  '${widget.speed}',
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
                                  PHelperFunctions.getPace(widget.pace),
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
                            style: TextStyle(
                                fontSize: 16, color: PColors.darkGrey),
                          ),
                          Row(
                            children: [
                              Text(
                                '${widget.calories}',
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontFamily: 'Helvetica',
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                  width: PSizes.spaceBtwInputFields / 2),
                              const Text(
                                'ккал',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontFamily: 'Helvetica',
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: PSizes.spaceBtwSections),
                        ]),
                    const Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Карта',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Helvetica',
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 220, // Устанавливаем желаемую высоту карты
                      child: YandexMap(
                        mapObjects: [
                          PolylineMapObject(
                            mapId: const MapObjectId('polyline'),
                            polyline: Polyline(
                              points: widget.locationHistory.map((location) {
                                return Point(
                                  latitude: location['lat'] ?? 0.0,
                                  longitude: location['long'] ?? 0.0,
                                );
                              }).toList(),
                            ),
                          ),
                          if (widget.startMarker != null) widget.startMarker!,
                          if (widget.endMarker != null) widget.endMarker!,
                        ],
                        onMapCreated: (YandexMapController controller) {
                          final points = widget.locationHistory.map((location) {
                            return Point(
                                latitude: location['lat']!,
                                longitude: location['long']!);
                          }).toList();
                          print(points);

                          if (points.isNotEmpty) {
                            controller.moveCamera(
                              CameraUpdate.newCameraPosition(
                                CameraPosition(
                                  target: points.first,
                                  zoom: 20.0, // Устанавливаем нужный зум
                                ),
                              ),
                            );
                          }
                        },
                      ),
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
                                      widget.steps,
                                      widget.distance,
                                      widget.speed,
                                      widget.pace,
                                      widget.calories,
                                      widget.timer,
                                      widget.date_start,
                                      widget.date_stop,
                                    )
                                : null,
                            style: ElevatedButton.styleFrom(
                              side: const BorderSide(
                                  color: Color.fromARGB(0, 0, 0, 0)),
                              backgroundColor: PColors.primary,
                            ),
                            child: const Text('Сохранить'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Future createWorkout(steps, distance, speed, pace, calories, timer,
      date_start, date_stop) async {
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
            'steps': steps.toString(),
            'distance': distance.toString(),
            'speed': speed.toString(),
            'pace': pace.toString(),
            'calories': calories.toString(),
            'duration': timer.toString(),
            'date_start': date_start.toString(),
            'date_stop': date_stop.toString(),
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

  void updateRoutePolyline() {
    setState(() {
      // Добавление маркера конечной точки маршрута
      if (widget.locationHistory.isNotEmpty) {
        print(widget.locationHistory);
      }
    });
    PolylineMapObject? routePolyline;
    if (widget.locationHistory.isNotEmpty) {
      final points = widget.locationHistory.map((location) {
        return Point(latitude: location['lat']!, longitude: location['long']!);
      }).toList();

      routePolyline = PolylineMapObject(
        mapId: const MapObjectId('route_polyline'),
        polyline: Polyline(points: points),
        strokeColor: Colors.blue,
        strokeWidth: 5,
        zIndex: 1,
      );
    }
  }
}
