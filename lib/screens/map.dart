import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:restazo_user_mobile/dart_assets/map_style.dart';

import 'package:restazo_user_mobile/providers/restaurants_near_you_provider.dart';
import 'package:restazo_user_mobile/providers/user_location_data_provider.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  late GoogleMapController mapController;
  LatLng? _center;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setMapInitCenter();
    });
  }

  void setMapInitCenter() {
    final locationData = ref.read(userLocationDataProvider);

    if (locationData == null) {
      _center = const LatLng(65.0121, 25.4651); // Default to some location
    } else {
      _center = LatLng(locationData.latitude!, locationData.longitude!);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void dispose() {
    mapController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantsNearYouProvider);

    Widget bodyContent = _center == null
        ? Center(
            child: LoadingAnimationWidget.dotsTriangle(
                color: Colors.white, size: 48),
          )
        : GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(target: _center!, zoom: 12.0),
            style: mapStyle,
            markers: state.data
                    ?.map(
                      (restaurant) => Marker(
                        markerId: MarkerId(restaurant.id),
                        position:
                            LatLng(restaurant.latitude, restaurant.longitude),
                        infoWindow: InfoWindow(title: restaurant.name),
                      ),
                    )
                    .toSet() ??
                {},
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
          );

    return Column(
      children: <Widget>[
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: bodyContent,
          ),
        ),
      ],
    );
  }
}
