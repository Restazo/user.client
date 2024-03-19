import 'package:flutter/material.dart';

class RestaurantNearYou {
  const RestaurantNearYou({
    required this.id,
    required this.addressLine,
    required this.affordability,
    required this.coverImage,
    required this.description,
    required this.name,
  });

  final String id;
  final Image coverImage;
  final String name;
  final String description;
  final String addressLine;
  final int affordability;
}
