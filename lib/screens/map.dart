import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restazo_user_mobile/providers/restaurants_near_you_notifier.dart';
import 'package:restazo_user_mobile/app_block/theme.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  late GoogleMapController mapController;

  
  final LatLng _center = const LatLng(65.0121, 25.4651);
  String? _mapStyle;
  bool _darkMode = false;

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

  void _toggleMapStyle(bool isDarkMode) {
    setState(() {
      _darkMode = isDarkMode;
    });
  }

  void _zoomIn() {
    mapController.animateCamera(CameraUpdate.zoomIn());
  }

  void _zoomOut() {
    mapController.animateCamera(CameraUpdate.zoomOut());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantsNearYouProvider);

    const double bottomNavBarHeight = 56.0;
    const double extraPadding = 16.0;
    const double fabBottomPadding = bottomNavBarHeight + extraPadding;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SwitchListTile(
              title: const Text('Toggle Dark Mode',
                  style: TextStyle(color: Colors.white)),
              value: _darkMode,
              onChanged: _toggleMapStyle,
              activeColor: appTheme.bottomNavigationBarTheme.selectedItemColor,
              inactiveThumbColor:
                  appTheme.bottomNavigationBarTheme.unselectedItemColor,
            ),
            Expanded(
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition:
                    CameraPosition(target: _center, zoom: 12.0),
                style: _darkMode ? _mapStyle : null,
                markers: state.data
                        ?.map(
                          (restaurant) => Marker(
                            markerId: MarkerId(restaurant.id),
                            position: LatLng(
                                restaurant.latitude, restaurant.longitude),
                            infoWindow: InfoWindow(
                                title: restaurant.name,
                                snippet: restaurant.description),
                          ),
                        )
                        .toSet() ??
                    {},
                zoomControlsEnabled: false,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: fabBottomPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: _zoomIn,
              materialTapTargetSize: MaterialTapTargetSize.padded,
              backgroundColor:
                  appTheme.bottomNavigationBarTheme.selectedItemColor,
              child: const Icon(Icons.add),
            ),
            const SizedBox(height: 10),
            FloatingActionButton(
              onPressed: _zoomOut,
              materialTapTargetSize: MaterialTapTargetSize.padded,
              backgroundColor: appTheme.textSelectionTheme.selectionHandleColor,
              child: const Icon(Icons.remove),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
