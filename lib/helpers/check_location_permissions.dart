import 'package:location/location.dart';

Future<bool> checkLocationPermissions() async {
  final Location location = Location();
  bool serviceEnabled;
  PermissionStatus permissionGranted;

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return false;
    }
  }

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied ||
      permissionGranted == PermissionStatus.deniedForever) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted == PermissionStatus.denied ||
        permissionGranted == PermissionStatus.deniedForever) {
      return false;
    }
  }
  return true;
}
