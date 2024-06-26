import 'package:flutter/material.dart';

import 'package:restazo_user_mobile/models/restaurant_near_you.dart';
import 'package:restazo_user_mobile/widgets/affordability_row.dart';

class RestaurantOverviewTextInfo extends StatelessWidget {
  const RestaurantOverviewTextInfo({super.key, required this.restaurantInfo});

  final RestaurantNearYou restaurantInfo;

  @override
  Widget build(BuildContext context) {
    // final String description =
    //     restaurantInfo.description != null ? restaurantInfo.description! : '';

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
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 32),
                        child: Text(
                          restaurantInfo.name,
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  color: Colors.white,
                                  fontSize: 24,
                                  height: 1,
                                  overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ),
                    AffordabilityRow(
                      affordability: restaurantInfo.affordability,
                      fontSize:
                          Theme.of(context).textTheme.titleLarge!.fontSize!,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 32),
                        child: Text(
                          restaurantInfo.addressLine,
                          maxLines: 1,
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Colors.white,
                                    height: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                        ),
                      ),
                    ),
                    Text(
                      "${restaurantInfo.distanceKm} km",
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
          if (restaurantInfo.description != null &&
              restaurantInfo.description!.isNotEmpty)
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
                  restaurantInfo.description!,
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
