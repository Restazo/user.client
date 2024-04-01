import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:restazo_user_mobile/models/restaurant_near_you.dart';

class RestaurantNearYouCard extends StatelessWidget {
  const RestaurantNearYouCard({super.key, required this.restauranInfo});

  final RestaurantNearYou restauranInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(25, 255, 255, 255),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 6,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              context.go(
                '/restaurants/${restauranInfo.id}',
                extra: restauranInfo,
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: const Offset(4, 0),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: restauranInfo.coverImage,
                      height: 128,
                      width: 128,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 128,
                        width: 128,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(50, 255, 255, 255)),
                      ),
                      // const RestaurantNearYouCoverLoader(),
                      errorWidget: (context, url, error) => Container(
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 60, 60, 60)),
                        child: const Icon(
                          Icons.error,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 16,
                      bottom: 10,
                      right: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 18.0),
                          child: Text(
                            restauranInfo.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 18,
                                ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          height: 48,
                          padding: const EdgeInsets.only(right: 14),
                          child: Text(
                            restauranInfo.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                  color:
                                      const Color.fromARGB(255, 222, 222, 222),
                                  // fontSize: 12,
                                ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 24.0),
                                child: Text(
                                  restauranInfo.addressLine,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        fontSize: 12,
                                        color: const Color.fromARGB(
                                            255, 222, 222, 222),
                                      ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 0,
                              child: Row(
                                children: [
                                  Text(
                                    "\$",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          color:
                                              restauranInfo.affordability >= 1
                                                  ? Colors.white
                                                  : const Color.fromARGB(
                                                      255, 144, 144, 144),
                                        ),
                                  ),
                                  Text(
                                    "\$",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          color:
                                              restauranInfo.affordability >= 2
                                                  ? Colors.white
                                                  : const Color.fromARGB(
                                                      255, 144, 144, 144),
                                        ),
                                  ),
                                  Text(
                                    "\$",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          color:
                                              restauranInfo.affordability >= 3
                                                  ? Colors.white
                                                  : const Color.fromARGB(
                                                      255, 144, 144, 144),
                                        ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
