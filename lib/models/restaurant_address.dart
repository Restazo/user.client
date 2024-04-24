class RestaurantAddress {
  const RestaurantAddress({
    required this.addressLine,
    required this.city,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
    required this.postalCode,
    required this.distanceKm,
  });

  final String addressLine;
  final String city;
  final String postalCode;
  final String countryCode;
  final double latitude;
  final double longitude;
  final double distanceKm;

  factory RestaurantAddress.fromJson(Map<String, dynamic> addressJson) {
    return RestaurantAddress(
      addressLine: addressJson['addressLine'] as String,
      city: addressJson['city'] as String,
      countryCode: addressJson['countryCode'] as String,
      postalCode: addressJson['postalCode'] as String,
      latitude: addressJson['latitude'] as double,
      longitude: addressJson['longitude'] as double,
      distanceKm: addressJson['distanceKm'] as double,
    );
  }
}
