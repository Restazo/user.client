import 'package:location/location.dart';
import 'package:restazo_user_mobile/helpers/check_location_permissions.dart';

Future<LocationData?> getCurrentLocation() async {
  final Location location = Location();

  if (!(await checkLocationPermissions())) {
    return null;
  }

  return await location.getLocation();
}
