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
    required this.logoImage,
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
  final String? logoImage;

  factory RestaurantNearYou.fromJson(Map<String, dynamic> restaurantDataJson) {
    return RestaurantNearYou(
      id: restaurantDataJson['id'] as String,
      coverImage: restaurantDataJson['coverImage'] as String?,
      name: restaurantDataJson['name'] as String,
      description: restaurantDataJson['description'] as String?,
      addressLine: restaurantDataJson['addressLine'] as String,
      affordability: restaurantDataJson['affordability'] as int,
      longitude: restaurantDataJson['longitude'] as double,
      latitude: restaurantDataJson['latitude'] as double,
      distanceKm: (restaurantDataJson['distanceKm']).toDouble() as double,
      logoImage: restaurantDataJson['logoImage'] as String?,
    );
  }
}
