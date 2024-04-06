class RestaurantAddress {
  const RestaurantAddress({
    required this.addressLine,
    required this.city,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
    required this.postalCode,
  });

  final String addressLine;
  final String city;
  final String postalCode;
  final String countryCode;
  final double latitude;
  final double longitude;

  factory RestaurantAddress.fromJson(Map<String, dynamic> addressJson) {
    return RestaurantAddress(
      addressLine: addressJson['addressLine'],
      city: addressJson['city'],
      countryCode: addressJson['countryCode'],
      latitude: double.parse(addressJson['latitude'] as String),
      longitude: double.parse(addressJson['longitude'] as String),
      postalCode: addressJson['postalCode'],
    );
  }
}
