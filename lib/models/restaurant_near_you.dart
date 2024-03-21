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

  factory RestaurantNearYou.fromJson(Map<String, dynamic> json) {
    return RestaurantNearYou(
      id: json['id'] as String,
      coverImage: json['coverImage'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      addressLine: json['addressLine'] as String,
      affordability: json['affordability'] as int,
      longitude: double.parse(json['longitude'] as String),
      latitude: double.parse(json['latitude'] as String),
    );
  }
}
