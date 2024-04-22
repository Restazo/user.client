import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restazo_user_mobile/providers/restaurants_near_you_notifier.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(65.0121, 25.4651);
  String? _mapStyle;

  @override
  void initState() {
    super.initState();
    ref.read(restaurantsNearYouProvider.notifier).loadRestaurantsNearYou(1.0);
    _loadMapStyle();
  }

  Future<void> _loadMapStyle() async {
    _mapStyle = await rootBundle.loadString('assets/dark_map_style.json');
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantsNearYouProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition:
                    CameraPosition(target: _center, zoom: 12.0),
                style: _mapStyle,
                markers: state.data
                        ?.map(
                          (restaurant) => Marker(
                            markerId: MarkerId(restaurant.id),
                            position: LatLng(
                                restaurant.latitude, restaurant.longitude),
                            infoWindow: InfoWindow(
                                title: restaurant.name),
                          ),
                        )
                        .toSet() ??
                    {},
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
