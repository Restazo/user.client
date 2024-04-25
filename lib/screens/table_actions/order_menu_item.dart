import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restazo_user_mobile/helpers/currency.dart';
import 'package:restazo_user_mobile/helpers/renavigations.dart';
import 'package:restazo_user_mobile/models/menu_item.dart';
import 'package:restazo_user_mobile/providers/order_menu_item_provider.dart';
import 'package:restazo_user_mobile/widgets/app_bar.dart';
import 'package:restazo_user_mobile/widgets/error_widgets/error_screen.dart';

class OrderMenuItemScreen extends ConsumerStatefulWidget {
  const OrderMenuItemScreen({super.key});

  @override
  ConsumerState<OrderMenuItemScreen> createState() =>
      _OrderMenuItemScreenState();
}

class _OrderMenuItemScreenState extends ConsumerState<OrderMenuItemScreen> {
  MenuItem? menuItemData;

  @override
  void initState() {
    super.initState();
    loadMenuItemData();
  }

  void loadMenuItemData() {
    setState(() {
      menuItemData = ref.read(orderMenuItemProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = ErrorScreenWithAction(
      baseMessageWidget: Center(
        child: Text(
          "Something went wrong",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Colors.white,
              ),
        ),
      ),
    );

    if (menuItemData != null) {
      Widget coverWidget = menuItemData!.imageUrl != null
          ? CachedNetworkImage(
              imageUrl: menuItemData!.imageUrl!,
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
              height: 128,
              width: 128,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(50, 255, 255, 255)),
              child: Container(
                decoration:
                    const BoxDecoration(color: Color.fromARGB(255, 60, 60, 60)),
                child: const Icon(
                  Icons.food_bank_rounded,
                  color: Colors.white,
                ),
              ),
            );

      content = Padding(
        padding: const EdgeInsets.only(
            // top: 24,
            // left: 20,
            // right: 20,
            // bottom: 36,
            ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 24),
              child: ListView(
                children: [
                  Container(
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: AspectRatio(
                        aspectRatio: 350 / 214,
                        child: coverWidget,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: Text(
                                    menuItemData!.name,
                                    maxLines: 1,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            color: Colors.white,
                                            fontSize: 20,
                                            height: 1,
                                            overflow: TextOverflow.ellipsis),
                                  ),
                                ),
                              ),
                              Text(
                                '${menuItemData!.priceAmount}${CurrencyHelper.getSymbol(menuItemData!.priceCurrency)}',
                                maxLines: 1,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                        color: Colors.white,
                                        fontSize: 20,
                                        height: 1,
                                        overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                          SizedBox(
                              height:
                                  menuItemData!.description != null ? 16 : 0),
                          Text(
                            menuItemData!.description ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                  color: Colors.white,
                                  fontSize: menuItemData!.description != null
                                      ? 12
                                      : 0,
                                ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ingredients',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: Colors.white,
                                  height: 1,
                                ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            menuItemData!.ingredients,
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Colors.white,
                                    ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 36,
              left: 20,
              right: 20,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  overlayColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return const Color.fromARGB(255, 200, 200, 200);
                      }
                      return null;
                    },
                  ),
                ),
                onPressed: () {},
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    'Scan table QR',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Colors.black,
                        ),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: RestazoAppBar(
        leftNavigationIconAction: () {
          ref.read(orderMenuItemProvider.notifier).leaveOrderMenuItemScreen();

          navigateBack(context);
        },
        leftNavigationIconAsset: 'assets/left.png',
      ),
      body: content,
    );
  }
}
