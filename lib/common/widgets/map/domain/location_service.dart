import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../domain/app_lat_long.dart';
import '../domain/app_location.dart';

class LocationService implements AppLocation {
  final defLocation = const MoscowLocation();

  @override
  Future<AppLatLong> getCurrentLocation() async {
    return Geolocator.getCurrentPosition().then((value) {
      return AppLatLong(lat: value.latitude, long: value.longitude);
    }).catchError(
      (_) => defLocation,
    );
  }

  @override
  Future<bool> requestPermission() {
    return Geolocator.requestPermission()
        .then((value) =>
            value == LocationPermission.always ||
            value == LocationPermission.whileInUse)
        .catchError((_) => false);
  }

  @override
  Future<bool> checkPermission() {
    return Geolocator.checkPermission()
        .then((value) =>
            value == LocationPermission.always ||
            value == LocationPermission.whileInUse)
        .catchError((_) => false);
  }

  Future<bool> requestPhysicalActivityPermission() {
    return Permission.activityRecognition
        .request()
        .then((status) =>
            status == PermissionStatus.granted ||
            status == PermissionStatus.limited)
        .catchError((_) => false);
  }

  Future<bool> checkPhysicalActivityPermission() {
    return Permission.activityRecognition.status
        .then((status) =>
            status == PermissionStatus.granted ||
            status == PermissionStatus.limited)
        .catchError((_) => false);
  }
}
