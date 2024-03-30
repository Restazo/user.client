import 'package:flutter/material.dart';

class RestaurantOverviewTextInfo extends StatelessWidget {
  const RestaurantOverviewTextInfo({super.key});

  // TODO: make a model for this info
  // Use it in here with variables
  // final RestaurantOverviewInfo restaurantInfo;

  @override
  Widget build(BuildContext context) {
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
                      "Restaurant Name",
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
                      "Restaurant Street",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.white,
                            height: 1,
                          ),
                    ),
                    const Spacer(),
                    Text(
                      "Distance",
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
                "Embark on a gastronomic journey like no other at La Maison Gastronomique, where every corner whispers tales of culinary mastery and every dish beckons with irresistible allure.",
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
