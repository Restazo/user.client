import 'package:location/location.dart';
import 'package:restazo_user_mobile/helpers/check_location_permissions.dart';

Future<LocationData?> getCurrentLocation() async {
  final Location location = Location();

  final granted = await checkLocationPermissions();

  if (!granted) {
    return null;
  }

  final userLocation = await location.getLocation();
  return userLocation;
}
