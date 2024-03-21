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
  });

  final String id;
  final String coverImage;
  final String name;
  final String description;
  final String addressLine;
  final int affordability;
  final double longitude;
  final double latitude;
}
