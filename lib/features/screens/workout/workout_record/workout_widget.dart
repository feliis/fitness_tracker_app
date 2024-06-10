import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:pedometer/pedometer.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../../../common/widgets/appbar.dart';
import '../../../../common/widgets/map/domain/app_lat_long.dart';
import '../../../../common/widgets/map/domain/location_service.dart';
import '../../../../utils/const/colors.dart';
import '../../../../utils/const/sizes.dart';
import '../../../../utils/helper_functions.dart';
import 'workoutres_page.dart';

class WorkoutWidget extends StatefulWidget {
  const WorkoutWidget({Key? key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<WorkoutWidget> {
  Map<String, dynamic>? selectedActivity;
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  bool _isRecordWorkout = false, _isFirstWidgetVisible = false;
  String _status = '?';
  int _steps = 0,
      _stepsPrev = 0,
      _stepsNow = 0,
      calories = 0,
      milisecond = 0,
      time = 0;
  double dist = 0.00, speed = 0.00, weight = 68.5, height = 170.0, pace = 0.00;
  double? met = 0.00;
  late DateTime date_start, date_stop;
  String buttonText = 'Начать',
      avg_pace = '0' + "'00" + '"',
      titleScreen = 'Тренировка',
      type_activity = '';
  Icon iconButton = Icon(Iconsax.location);
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

  final mapControllerCompleter = Completer<YandexMapController>();
  PlacemarkMapObject? userLocationMarker;
  PolylineMapObject? routePolyline;
  PlacemarkMapObject? startMarker;
  PlacemarkMapObject? endMarker;
  List<Map<String, double>> locationHistory = [];
  bool isRecording = false;

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    initPlatformState();
    initPermission().ignore();
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (isRecording) {
        fetchCurrentLocation();
      }
    });
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = PHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: PAppBar(
        showBackArrow: false,
        title: Text(titleScreen),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
            child: Column(
          children: [
            SizedBox(
              height: 650,
              child: Stack(children: <Widget>[
                Container(
                  child: MapScreen(
                      mapControllerCompleter: mapControllerCompleter,
                      userLocationMarker: userLocationMarker,
                      routePolyline: routePolyline,
                      startMarker: startMarker,
                      endMarker: endMarker),
                ),
                Visibility(
                  visible: !_isRecordWorkout,
                  child: Positioned(
                    bottom: 25,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: Opacity(
                        opacity: 0.9,
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: PColors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 25,
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: DropdownActivity(
                                        onActivitySelected: (activity) {
                                      setState(() {
                                        selectedActivity = activity;
                                      });
                                    }),
                                  ),
                                  SizedBox(height: PSizes.spaceBtwItems / 2),
                                  Text(
                                    'Выберите упражнение для начала тренировки',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.normal,
                                      color: PColors.darkGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                    visible: _isFirstWidgetVisible,
                    child: Container(
                      color: dark ? Colors.black : Colors.white,
                      child: TrackerWidget(
                          stopWatchTimer: _stopWatchTimer,
                          isHours: _isHours,
                          recordWorkout: _isRecordWorkout,
                          dist: dist,
                          steps: _steps,
                          speed: speed,
                          avg_pace: avg_pace,
                          calories: calories),
                    )),
              ]),
            ),

            const SizedBox(height: PSizes.spaceBtwSections),

            /// Buttons
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () =>
                        _isRecordWorkout ? onStop() : onStart(selectedActivity),
                    child: Text(buttonText),
                    style: ElevatedButton.styleFrom(
                      side: const BorderSide(color: Color.fromARGB(0, 0, 0, 0)),
                      backgroundColor: buttonColor,
                    ),
                  ),
                ),
                const SizedBox(width: PSizes.spaceBtwSections),
                Visibility(
                  visible: _isRecordWorkout,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: PColors.grey, // Цвет фона кнопки
                    ),
                    child: IconButton(
                      icon: _isFirstWidgetVisible
                          ? Icon(Iconsax.location)
                          : Icon(Iconsax.element_equal),
                      color: PColors.black, // Цвет иконки
                      onPressed: () => _toggleVisibility(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        )),
      ),
    );
  }

  void _toggleVisibility() {
    setState(() {
      _isFirstWidgetVisible = !_isFirstWidgetVisible;
    });
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
      double hours = (time / 3600000);
      double s = (dist / (hours));
      speed = double.parse(s.toStringAsFixed(2));
      double p = 60 / speed;

      // int paceSeconds =
      //     ((double.parse(p.toStringAsFixed(2)) - p.floor()) * 60).toInt();
      // int paceMinutes = p.toInt();
      pace = p;
      if (p != double.infinity) {
        int paceSeconds =
            ((double.parse(p.toStringAsFixed(2)) - p.floor()) * 60).toInt();
        int paceMinutes = p.toInt();
        avg_pace = paceMinutes.toString() + "'" + paceSeconds.toString() + '"';
      }

      // double c = (0.035 * weight + (speed / height) * 0.029 * weight) * minutes;
      // calories = c.toInt();
      calories = (met! * weight * hours).toInt();
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

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String threeDigits(int n) => n.toString().padLeft(3, '0');

    String formattedTime =
        '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
    return formattedTime;
  }

  Future<void> initPermission() async {
    LocationService locationService = LocationService();

    bool hasLocationPermission = await locationService.checkPermission();
    bool hasPhysicalActivityPermission =
        await locationService.checkPhysicalActivityPermission();

    if (!hasLocationPermission || !hasPhysicalActivityPermission) {
      if (!hasLocationPermission) {
        await locationService.requestPermission();
      }
      if (!hasPhysicalActivityPermission) {
        await locationService.requestPhysicalActivityPermission();
      }
    }

    await fetchCurrentLocation();
  }

  Future<void> fetchCurrentLocation() async {
    AppLatLong location;
    const defLocation = MoscowLocation();
    try {
      location = await LocationService().getCurrentLocation();
    } catch (_) {
      location = defLocation;
    }
    addUserLocationMarker(location);
    moveToCurrentLocation(location);
    if (isRecording) {
      setState(() {
        moveToCurrentLocation(location);
        locationHistory.add({
          'lat': location.lat,
          'long': location.long,
        });
        updateRoutePolyline();
      });
    }
  }

  Future<void> moveToCurrentLocation(AppLatLong appLatLong) async {
    final controller = await mapControllerCompleter.future;

    controller.moveCamera(
      animation: const MapAnimation(type: MapAnimationType.linear, duration: 1),
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(
            latitude: appLatLong.lat,
            longitude: appLatLong.long,
          ),
          zoom: 18,
        ),
      ),
    );
  }

  void addUserLocationMarker(AppLatLong appLatLong) {
    userLocationMarker = PlacemarkMapObject(
      mapId: const MapObjectId('user_location'),
      point: Point(
        latitude: appLatLong.lat,
        longitude: appLatLong.long,
      ),
      icon: PlacemarkIcon.single(
        PlacemarkIconStyle(
          image:
              BitmapDescriptor.fromAssetImage('assets/map/user_location.png'),
          scale: 1,
        ),
      ),
      opacity: 1,
    );
    print(appLatLong.lat);
    print(appLatLong.long);
    setState(() {});
  }

  void updateRoutePolyline() {
    if (locationHistory.isNotEmpty) {
      final points = locationHistory.map((location) {
        return Point(latitude: location['lat']!, longitude: location['long']!);
      }).toList();
      print(points);
      routePolyline = PolylineMapObject(
        mapId: const MapObjectId('route_polyline'),
        polyline: Polyline(points: points),
        strokeColor: Colors.blue,
        strokeWidth: 5,
        zIndex: 1,
      );
    }
  }

  void startRecording() {
    setState(() {
      isRecording = true;
      startMarker = null;
      endMarker = null;
      locationHistory.clear(); // Очистка истории при новом старте записи

      // Добавление маркера начальной точки маршрута
      if (userLocationMarker != null) {
        final startPoint = userLocationMarker!.point;
        startMarker = PlacemarkMapObject(
          mapId: const MapObjectId('start_marker'),
          point: startPoint,
          icon: PlacemarkIcon.single(
            PlacemarkIconStyle(
              image: BitmapDescriptor.fromAssetImage(
                'assets/map/start_location.png',
              ),
              scale: 2.5,
            ),
          ),
          opacity: 1,
        );
      }
    });
  }

  void stopRecording() {
    setState(() {
      print(met);
      userLocationMarker = null;
      isRecording = false;
      // Добавление маркера конечной точки маршрута
      if (locationHistory.isNotEmpty) {
        final endLocation = locationHistory.last;
        endMarker = PlacemarkMapObject(
          mapId: const MapObjectId('end_marker'),
          point: Point(
            latitude: endLocation['lat']!,
            longitude: endLocation['long']!,
          ),
          icon: PlacemarkIcon.single(
            PlacemarkIconStyle(
              image: BitmapDescriptor.fromAssetImage(
                  'assets/map/end_location.png'),
              scale: 2.5,
            ),
          ),
          opacity: 1,
        );
        print(locationHistory);
      }
    });
  }

  void onStart(Map<String, dynamic>? selectedActivity) {
    if (selectedActivity == null) {
      return;
    }
    startRecording();
    setState(
      () {
        titleScreen = selectedActivity['name']!;
        type_activity = selectedActivity['id']!;
        met = selectedActivity['met'];
        _isFirstWidgetVisible = true;
        date_start = DateTime.now();
        _isRecordWorkout = true;
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
    stopRecording();
    date_stop = DateTime.now();
    _isRecordWorkout = false;
    _stopWatchTimer.onStopTimer();
    _stepsPrev = 0;
    _stepsNow = _steps;
    print(avg_pace);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutResultPage(
          timer: formatTime(_stopWatchTimer.rawTime.value),
          type_activity: type_activity,
          steps: _stepsNow,
          distance: dist,
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

class MapScreen extends StatelessWidget {
  const MapScreen({
    super.key,
    required this.mapControllerCompleter,
    required this.userLocationMarker,
    required this.routePolyline,
    required this.startMarker,
    required this.endMarker,
  });

  final Completer<YandexMapController> mapControllerCompleter;
  final PlacemarkMapObject? userLocationMarker;
  final PolylineMapObject? routePolyline;
  final PlacemarkMapObject? startMarker;
  final PlacemarkMapObject? endMarker;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: YandexMap(
            onMapCreated: (controller) async {
              mapControllerCompleter.complete(controller);
            },
            mapObjects: [
              if (userLocationMarker != null) userLocationMarker!,
              if (routePolyline != null) routePolyline!,
              if (startMarker != null) startMarker!,
              if (endMarker != null) endMarker!,
            ],
          ),
        ),
      ],
    );
  }
}

class TrackerWidget extends StatelessWidget {
  const TrackerWidget({
    super.key,
    required StopWatchTimer stopWatchTimer,
    required bool isHours,
    required this.recordWorkout,
    required this.dist,
    required int steps,
    required this.speed,
    required this.avg_pace,
    required this.calories,
  })  : _stopWatchTimer = stopWatchTimer,
        _isHours = isHours,
        _steps = steps;

  final StopWatchTimer _stopWatchTimer;
  final bool _isHours;
  final bool recordWorkout;
  final double dist;
  final int _steps;
  final double speed;
  final String avg_pace;
  final int calories;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                    const Text(
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
                    const Text(
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
                        const Text(
                          'км',
                          style: TextStyle(
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
                    const Text(
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
                    const Text(
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
                        const Text(
                          'км/ч',
                          style: TextStyle(
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
                    const Text(
                      'Темп',
                      style: TextStyle(fontSize: 18),
                    ),
                    Row(
                      children: [
                        Text(
                          recordWorkout ? avg_pace : '--',
                          style: const TextStyle(
                              fontSize: 28,
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: PSizes.spaceBtwInputFields),
                        const Text(
                          '/км',
                          style: TextStyle(
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
                const Text(
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
                    const Text(
                      'ккал',
                      style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'Helvetica',
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ));
  }
}

class DropdownActivity extends StatefulWidget {
  final Function(Map<String, dynamic>) onActivitySelected;

  const DropdownActivity({Key? key, required this.onActivitySelected})
      : super(key: key);

  @override
  _DropdownState createState() => _DropdownState();
}

class _DropdownState extends State<DropdownActivity> {
  Map<String, dynamic>? selectedActivity;

  List<Map<String, dynamic>> itemsDropdown = [];
  String? getActivity;

  @override
  void initState() {
    super.initState();
    getActivities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: DropdownButton<Map<String, dynamic>>(
                borderRadius: BorderRadius.circular(10),
                dropdownColor: PColors.white,
                hint: Text('Выберите упражнение'),
                value: selectedActivity,
                items: itemsDropdown.map((Map<String, dynamic> activity) {
                  return DropdownMenuItem<Map<String, dynamic>>(
                    value: activity,
                    child: Text(activity['name']!),
                  );
                }).toList(),
                onChanged: (Map<String, dynamic>? newValue) {
                  setState(() {
                    selectedActivity = newValue;
                  });
                  if (newValue != null) {
                    widget.onActivitySelected(newValue);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getActivities() async {
    var url = Uri.https('utterly-comic-parakeet.ngrok-free.app', "activities");
    print(url);
    var response = await http.get(url, headers: {
      "ngrok-skip-browser-warning": "true",
      "Content-Type": "application/json",
      "Accept": "application/json"
    });
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        itemsDropdown = data.map((activity) {
          return {
            'id': activity['id'] as String,
            'name': activity['name'] as String,
            'met': activity['met'],
          };
        }).toList();
      });
    } else {
      throw Exception('Failed to load activities');
    }
  }
}
