import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restazo_user_mobile/helpers/cancel_button.dart';
import 'package:restazo_user_mobile/helpers/renavigations.dart';
import 'package:restazo_user_mobile/models/order_menu_item.dart';
import 'package:restazo_user_mobile/providers/place_order_provider.dart';
import 'package:restazo_user_mobile/widgets/app_bar.dart';
import 'package:restazo_user_mobile/widgets/confirm_order.dart';
import 'package:restazo_user_mobile/widgets/menu_item.dart';

class ConfirmOrderScreen extends ConsumerStatefulWidget {
  const ConfirmOrderScreen({super.key});

  @override
  ConsumerState<ConfirmOrderScreen> createState() => _ConfirmOrderScreenState();
}

class _ConfirmOrderScreenState extends ConsumerState<ConfirmOrderScreen> {
  late List<OrderMenuItem> orderedMenuItems;

  @override
  void initState() {
    super.initState();
  }

  void _buildCOnfirmationModal(String currency, double total) {
    showCupertinoModalPopup(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: [
            ConfirmOrderPopUp(
              totalPrice: total,
              currency: currency,
            )
          ],
          cancelButton: buildCancelButton(
            context: context,
            onPressed: () {
              navigateBack(context);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(placeOrderProvider);

    final String currency =
        orderState.isNotEmpty ? orderState[0].itemData.priceCurrency : 'usd';

    double total = 0.0;

    for (OrderMenuItem orderItem in orderState) {
      total += orderItem.itemData.priceAmount * orderItem.itemAmount;
    }

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: RestazoAppBar(
        leftNavigationIconAction: () => navigateBack(context),
        leftNavigationIconAsset: 'assets/left.png',
        title: "Confirm order",
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 24,
          left: 20,
          right: 20,
        ),
        child: Stack(
          children: [
            ListView.builder(
              itemCount: orderState.length,
              itemBuilder: (context, index) {
                return MenuItemCard(
                  itemData: orderState[index].itemData,
                  itemAmount: orderState[index].itemAmount,
                );
              },
            ),
            if (orderState.isNotEmpty)
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.75),
                      blurRadius: 24,
                      spreadRadius: 24,
                      offset: const Offset(0, 24),
                    )
                  ]),
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
                    onPressed: () {
                      _buildCOnfirmationModal(currency, total);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        "Place the order",
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Colors.black,
                                ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
