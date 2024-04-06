import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restazo_user_mobile/helpers/currency.dart';

import 'package:restazo_user_mobile/models/menu_item.dart';
import 'package:restazo_user_mobile/router/app_router.dart';

class MenuItemCard extends StatefulWidget {
  const MenuItemCard({
    super.key,
    required this.itemData,
  });

  final MenuItem itemData;

  @override
  State<MenuItemCard> createState() => _MenuItemCardState();
}

class _MenuItemCardState extends State<MenuItemCard> {
  @override
  Widget build(BuildContext context) {
    final priceStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: Colors.white,
          fontSize: 16,
          height: 1,
          letterSpacing: 0,
        );

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(25, 255, 255, 255),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                spreadRadius: 6,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              // final Map<String, String> existingParametersMap =
              //     GoRouterState.of(context).pathParameters;

              // context.goNamed(
              //   ScreenNames.menuItemDetail.name,
              //   pathParameters: {
              //     'item_id': widget.itemData.id,
              //     ...existingParametersMap,
              //   },
              //   // extra: widget.itemData,
              // );
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
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: widget.itemData.imageUrl,
                      height: 96,
                      width: 128,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 96,
                        width: 128,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
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
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.itemData.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: Colors.white,
                                    fontSize: 16,
                                    height: 1,
                                    letterSpacing: 0,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 48,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 24),
                                  child: Text(
                                    widget.itemData.description,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          color: const Color.fromARGB(
                                              255, 222, 222, 222),
                                          fontSize: 10,
                                          height: 1.6,
                                        ),
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  const Spacer(),
                                  Row(
                                    children: [
                                      Text(
                                        widget.itemData.priceAmount,
                                        maxLines: 1,
                                        style: priceStyle,
                                      ),
                                      Text(
                                        CurrencyHelper.getSymbol(
                                            widget.itemData.priceCurrency),
                                        maxLines: 1,
                                        style: priceStyle,
                                      )
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        )
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
