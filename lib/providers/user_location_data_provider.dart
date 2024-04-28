import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:restazo_user_mobile/helpers/get_current_location.dart';

class LocationDataNotifier extends StateNotifier<LocationData?> {
  LocationDataNotifier() : super(null);

  Future<void> saveCurrentLocation() async {
    try {
      final locationData = await getCurrentLocation();

      state = locationData;
    } catch (e) {
      state = null;
    }
  }
}

final userLocationDataProvider =
    StateNotifierProvider<LocationDataNotifier, LocationData?>(
        (ref) => LocationDataNotifier());
