import 'package:fitness_tracker_app/common/widgets/circular_container.dart';
import 'package:fitness_tracker_app/common/widgets/curved_edges.dart';
import 'package:fitness_tracker_app/utils/const/colors.dart';
import 'package:fitness_tracker_app/utils/const/sizes.dart';
import 'package:fitness_tracker_app/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class WorkoutDetail extends StatelessWidget {
  const WorkoutDetail({
    super.key,
    required this.timer,
    required this.steps,
    required this.distance,
    required this.speed,
    required this.pace,
    required this.calories,
    required this.date_start,
    required this.date_stop,
    required this.locationHistory,
  });

  final String timer;
  final String steps;
  final String distance;
  final String speed;
  final String pace;
  final String calories;
  final String date_start;
  final String date_stop;
  final List<Map<String, double>> locationHistory;

  @override
  Widget build(BuildContext context) {
    final dark = PHelperFunctions.isDarkMode(context);
    return Container(
      color: dark ? PColors.black : PColors.white,
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
                    Positioned(
                      top: 85,
                      left: 25,
                      child: Row(
                        children: [
                          Text(
                            distance,
                            style: const TextStyle(
                              fontSize: 32,
                              color: PColors.white,
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          const SizedBox(width: PSizes.spaceBtwInputFields),
                          const Text(
                            'км',
                            style: TextStyle(
                              fontSize: 32,
                              color: PColors.white,
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: -150,
                      right: -250,
                      child: CircularContainer(
                          backgroundColor: PColors.textWhite.withOpacity(0.1)),
                    ),
                    Positioned(
                      top: 100,
                      right: -300,
                      child: CircularContainer(
                          backgroundColor: PColors.textWhite.withOpacity(0.1)),
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
                          color: PColors.black,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                          decorationColor: null),
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
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.none,
                          decorationColor: null),
                    ),
                    Text(
                      timer,
                      style: const TextStyle(
                          fontSize: 22,
                          fontFamily: 'Helvetica',
                          color: PColors.black,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                          decorationColor: null),
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
                              fontSize: 16,
                              color: PColors.darkGrey,
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.none,
                              decorationColor: null),
                        ),
                        Row(
                          children: [
                            Text(
                              distance,
                              style: const TextStyle(
                                  fontSize: 22,
                                  fontFamily: 'Helvetica',
                                  color: PColors.black,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none,
                                  decorationColor: null),
                            ),
                            const SizedBox(
                                width: PSizes.spaceBtwInputFields / 2),
                            const Text(
                              'км',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontFamily: 'Helvetica',
                                  color: PColors.black,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none,
                                  decorationColor: null),
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
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.none,
                              decorationColor: null),
                        ),
                        Text(
                          steps,
                          style: const TextStyle(
                              fontSize: 22,
                              fontFamily: 'Helvetica',
                              color: PColors.black,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                              decorationColor: null),
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
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.none,
                              decorationColor: null),
                        ),
                        Row(
                          children: [
                            Text(
                              speed,
                              style: const TextStyle(
                                  fontSize: 22,
                                  fontFamily: 'Helvetica',
                                  color: PColors.black,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none,
                                  decorationColor: null),
                            ),
                            const SizedBox(
                                width: PSizes.spaceBtwInputFields / 2),
                            const Text(
                              'км/ч',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontFamily: 'Helvetica',
                                  color: PColors.black,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none,
                                  decorationColor: null),
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
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.none,
                              decorationColor: null),
                        ),
                        Row(
                          children: [
                            Text(
                              PHelperFunctions.getPace(double.parse(pace)),
                              style: const TextStyle(
                                  fontSize: 22,
                                  fontFamily: 'Helvetica',
                                  color: PColors.black,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none,
                                  decorationColor: null),
                            ),
                            const SizedBox(
                                width: PSizes.spaceBtwInputFields / 2),
                            const Text(
                              '/км',
                              style: TextStyle(
                                fontSize: 22,
                                fontFamily: 'Helvetica',
                                color: PColors.black,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                                decorationColor: null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: PSizes.spaceBtwItems),

                /// Calories
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text(
                    'Калории тренировки',
                    style: TextStyle(
                        fontSize: 16,
                        color: PColors.darkGrey,
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.none,
                        decorationColor: null),
                  ),
                  Row(
                    children: [
                      Text(
                        calories,
                        style: const TextStyle(
                          fontSize: 22,
                          fontFamily: 'Helvetica',
                          color: PColors.black,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                          decorationColor: null,
                        ),
                      ),
                      const SizedBox(width: PSizes.spaceBtwInputFields / 2),
                      const Text(
                        'ккал',
                        style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'Helvetica',
                          color: PColors.black,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                          decorationColor: null,
                        ),
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
                              color: PColors.black,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                              decorationColor: null),
                        ),
                      ],
                    ),
                    const SizedBox(height: PSizes.spaceBtwInputFields),
                  ],
                ),
                SizedBox(
                  height: 220, // Устанавливаем желаемую высоту карты
                  child: YandexMap(
                    mapObjects: [
                      PolylineMapObject(
                        mapId: const MapObjectId('polyline'),
                        polyline: Polyline(
                          points: locationHistory.map((location) {
                            return Point(
                              latitude: location['lat'] ?? 0.0,
                              longitude: location['long'] ?? 0.0,
                            );
                          }).toList(),
                        ),
                      ),
                      PlacemarkMapObject(
                        mapId: const MapObjectId('start_marker'),
                        point: Point(
                          latitude: locationHistory.first['lat']!,
                          longitude: locationHistory.first['long']!,
                        ),
                        icon: PlacemarkIcon.single(
                          PlacemarkIconStyle(
                            image: BitmapDescriptor.fromAssetImage(
                                'assets/map/start_location.png'),
                            scale: 2.5,
                          ),
                        ),
                        opacity: 1,
                      ),
                      PlacemarkMapObject(
                        mapId: const MapObjectId('end_marker'),
                        point: Point(
                          latitude: locationHistory.last['lat']!,
                          longitude: locationHistory.last['long']!,
                        ),
                        icon: PlacemarkIcon.single(
                          PlacemarkIconStyle(
                            image: BitmapDescriptor.fromAssetImage(
                                'assets/map/end_location.png'),
                            scale: 2.5,
                          ),
                        ),
                        opacity: 1,
                      ),
                    ],
                    onMapCreated: (YandexMapController controller) {
                      final points = locationHistory.map((location) {
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
                              zoom: 18.0,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
