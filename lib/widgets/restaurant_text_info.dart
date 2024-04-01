import 'package:flutter/material.dart';
import 'package:restazo_user_mobile/models/restaurant_near_you.dart';

class RestaurantOverviewTextInfo extends StatelessWidget {
  const RestaurantOverviewTextInfo({super.key, required this.restaurantInfo});

  final RestaurantNearYou restaurantInfo;

  @override
  Widget build(BuildContext context) {
    final String description =
        restaurantInfo.description != null ? restaurantInfo.description! : '';

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white.withOpacity(0.1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 10,
            spreadRadius: 6,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: 16,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      restaurantInfo.name,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.white,
                            fontSize: 24,
                            height: 1,
                          ),
                    ),
                    const Spacer(),
                    Text(
                      "\$\$\$",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.white,
                            height: 1,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      restaurantInfo.addressLine,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.white,
                            height: 1,
                          ),
                    ),
                    const Spacer(),
                    Text(
                      "${restaurantInfo.distanceKm.toString()} km",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.white,
                            height: 1,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white.withOpacity(0.1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 8,
                  offset: const Offset(0, -4),
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Text(
                description,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.white,
                      height: 1.6,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
