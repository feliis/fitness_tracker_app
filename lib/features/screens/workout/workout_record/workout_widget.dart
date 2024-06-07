import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../../../common/widgets/appbar.dart';
import '../../../../common/widgets/map/domain/app_lat_long.dart';
import '../../../../common/widgets/map/domain/location_service.dart';
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
  bool recordWorkout = false,_isFirstWidgetVisible = true;
  String _status = '?';
  int _steps = 0,
      _stepsPrev = 0,
      _stepsNow = 0,
      calories = 0,
      milisecond = 0,
      time = 0;
  double dist = 0.00, speed = 0.00, weight = 68.5, height = 170.0, pace = 0.00;
  late DateTime date_start, date_stop;
  String buttonText = 'Начать', avg_pace = '0' + "'00" + '"';
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
    return Scaffold(
      appBar: const PAppBar(
        showBackArrow: false,
        title: Text('Тренировка'),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          
          child: Column
          (
            children: [
              SizedBox(
                height: 650,
                child: 
              Stack(
                children: <Widget>[
                  Visibility(
                    visible: _isFirstWidgetVisible,
                    child: Container(
                      child: 
                        TrackerWidget(stopWatchTimer: _stopWatchTimer, isHours: _isHours, recordWorkout: recordWorkout, dist: dist, steps: _steps, speed: speed, avg_pace: avg_pace, calories: calories),
                    )),
                  Visibility(
                    visible: !_isFirstWidgetVisible,
                    child: Container(
                      child: 
                        MapScreen(mapControllerCompleter: mapControllerCompleter, userLocationMarker: userLocationMarker, routePolyline: routePolyline, startMarker: startMarker, endMarker: endMarker),
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
                      child: 
                      ElevatedButton(
                    onPressed: recordWorkout ? onStop : onStart,
                    child: Text(buttonText),
                    style: ElevatedButton.styleFrom(
                      side: const BorderSide(color: Color.fromARGB(0, 0, 0, 0)),
                      backgroundColor: buttonColor,
                    ),
                ),
                    ),
                  const SizedBox(width: PSizes.spaceBtwSections),
                  Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: PColors.grey,  // Цвет фона кнопки
                  ),
                  child: IconButton(
                    icon: _isFirstWidgetVisible ? Icon(Iconsax.location) : Icon(Iconsax.element_equal),
                    color: PColors.black,  // Цвет иконки
                    onPressed: () {
                    setState(() {
                      fetchCurrentLocation();

                      _isFirstWidgetVisible = !_isFirstWidgetVisible; // Переключение состояния видимости виджетов
                    });},
                  ),
                )],
              ),
              
          ],)
          
          ),
        ),
    );
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
      if (p != double.infinity) {
        int paceSeconds =
            ((double.parse(p.toStringAsFixed(2)) - p.floor()) * 60).toInt();
        int paceMinutes = p.toInt();
        avg_pace = paceMinutes.toString() + "'" + paceSeconds.toString() + '"';
      }

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

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String threeDigits(int n) => n.toString().padLeft(3, '0');

    String formattedTime =
        '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
    return formattedTime;
  }

Future<void> initPermission() async {
    if (!await LocationService().checkPermission()) {
      await LocationService().requestPermission();
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
    print('---------------------------');
    print(location);
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

      routePolyline = PolylineMapObject(
        mapId: const MapObjectId('route_polyline'),
        polyline: Polyline(points: points),
        strokeColor: Colors.blue,
        strokeWidth: 5,
        zIndex: 1,
      );

      setState(() {});
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
      }
    });
  }

  void onStart() {
    startRecording();
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
    stopRecording();
    date_stop = DateTime.now();
    recordWorkout = false;
    _stopWatchTimer.onStopTimer();
    _stepsPrev = 0;
    _stepsNow = _steps;
    print(avg_pace);
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
          date_stop: date_stop,
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
  }) : _stopWatchTimer = stopWatchTimer, _isHours = isHours, _steps = steps;

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
                  ],)
                  
        
                );
  }
}
