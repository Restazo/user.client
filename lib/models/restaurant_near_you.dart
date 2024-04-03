class RestaurantNearYou {
  const RestaurantNearYou({
    required this.id,
    required this.addressLine,
    required this.affordability,
    required this.coverImage,
    required this.description,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.distanceKm,
  });

  final String id;
  final String? coverImage;
  final String name;
  final String? description;
  final String addressLine;
  final int affordability;
  final double longitude;
  final double latitude;
  final double distanceKm;
  // final String? logoImage;

  factory RestaurantNearYou.fromJson(Map<String, dynamic> restaurantDataJson) {
    return RestaurantNearYou(
      id: restaurantDataJson['id'] as String,
      coverImage: restaurantDataJson['coverImage'] as String?,
      name: restaurantDataJson['name'] as String,
      description: restaurantDataJson['description'] as String?,
      addressLine: restaurantDataJson['addressLine'] as String,
      affordability: restaurantDataJson['affordability'] as int,
      longitude: double.parse(restaurantDataJson['longitude'] as String),
      latitude: double.parse(restaurantDataJson['latitude'] as String),
      // TODO: uncomment these lines when hotfix/image_pathing is merged into main in user.api repo:
      // distanceKm: restaurantDataJson['distanceKm'],
      // logoImage: restaurantDataJson['logoImage'] as String?,
      distanceKm: restaurantDataJson['distance_km'],
    );
  }
}
