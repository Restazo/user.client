import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RestaurantOverviewImages extends StatelessWidget {
  const RestaurantOverviewImages({
    super.key,
    required this.coverImage,
    required this.logoImage,
  });

  final String? coverImage;
  final String? logoImage;

  @override
  Widget build(BuildContext context) {
    final Widget dynamicCoverImage = coverImage != null
        ? CachedNetworkImage(
            imageUrl: coverImage!,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(50, 255, 255, 255),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              decoration:
                  const BoxDecoration(color: Color.fromARGB(255, 60, 60, 60)),
              child: const Icon(
                Icons.error,
                color: Colors.white,
              ),
            ),
          )
        : Container(
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 60, 60, 60)),
            child: const Icon(
              Icons.food_bank_rounded,
              color: Colors.white,
            ),
          );

    final Widget dynamicLogoImage = logoImage != null
        ? CachedNetworkImage(
            imageUrl: logoImage!,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(50, 255, 255, 255),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              decoration:
                  const BoxDecoration(color: Color.fromARGB(255, 60, 60, 60)),
              child: const Icon(
                Icons.error,
                color: Colors.white,
              ),
            ),
          )
        : Container(
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 60, 60, 60)),
            child: const Icon(
              Icons.food_bank_rounded,
              color: Colors.white,
            ),
          );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            spreadRadius: 8,
            blurRadius: 10,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: AspectRatio(
              aspectRatio: 350 / 214,
              child: dynamicCoverImage,
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.78),
                    spreadRadius: 10,
                    blurRadius: 20,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: dynamicLogoImage,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
