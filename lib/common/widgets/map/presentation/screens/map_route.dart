import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../domain/app_lat_long.dart';
import '../../domain/location_service.dart';

class MapRoute extends StatefulWidget {
  const MapRoute({Key? key}) : super(key: key);

  @override
  State<MapRoute> createState() => MapScreenState();
}

class MapScreenState extends State<MapRoute> {
  final mapControllerCompleter = Completer<YandexMapController>();
  PlacemarkMapObject? userLocationMarker;
  PolylineMapObject? routePolyline;
  PlacemarkMapObject? startMarker;
  PlacemarkMapObject? endMarker;
  List<Map<String, double>> locationHistory = [];
  bool isRecording = false;

  @override
  void initState() {
    super.initState();
    initPermission().ignore();
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (isRecording) {
        fetchCurrentLocation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
      ),
    );
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
    moveToCurrentLocation(location);
    addUserLocationMarker(location);

    if (isRecording) {
      setState(() {
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
          zoom: 20,
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
}
