import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:restazo_user_mobile/env.dart';
import 'package:restazo_user_mobile/helpers/currency.dart';
import 'package:restazo_user_mobile/helpers/renavigations.dart';
import 'package:restazo_user_mobile/helpers/show_cupertino_dialog_with_one_action.dart';
import 'package:restazo_user_mobile/helpers/user_app_api.dart';
import 'package:restazo_user_mobile/models/order_menu_item.dart';
import 'package:restazo_user_mobile/providers/place_order_button_provider.dart';
import 'package:restazo_user_mobile/providers/place_order_provider.dart';
import 'package:restazo_user_mobile/router/app_router.dart';
import 'package:restazo_user_mobile/strings.dart';

class ConfirmOrderPopUp extends ConsumerStatefulWidget {
  const ConfirmOrderPopUp({
    super.key,
    required this.totalPrice,
    required this.currency,
  });

  final double totalPrice;
  final String currency;

  @override
  ConsumerState<ConfirmOrderPopUp> createState() => _ConfirmOrderPopUpState();
}

class _ConfirmOrderPopUpState extends ConsumerState<ConfirmOrderPopUp> {
  bool _isLoading = false;

  Future<void> _confirmOrder() async {
    setState(() {
      _isLoading = true;
    });
    const storage = FlutterSecureStorage();

    final fullOrderData = ref.read(placeOrderProvider);

    final processingOrderData = fullOrderData
        .map((fullItemData) => OrderProcessingMenuItem(
              itemAmount: fullItemData.itemAmount,
              itemId: fullItemData.itemData.id,
              itemName: fullItemData.itemData.name,
            ))
        .toList();

    final orderResult = await APIService().placeAnOrder(processingOrderData);

    if (!orderResult.isSuccess) {
      if (mounted) {
        showCupertinoDialogWithOneAction(
            context, "Fail", orderResult.errorMessage!, Strings.ok, () {
          navigateBack(context);
        });
      }
      return;
    }

    await storage.write(key: orderIdKeyname, value: orderResult.data!.orderId);
    ref.read(placeOrderProvider.notifier).deleteOrderData();
    ref
        .read(placeOrderButtonProvider.notifier)
        .updateButtonLabel("Check my order");

    setState(() {
      _isLoading = false;
    });
    if (mounted) {
      context.goNamed(
        ScreenNames.orderProcessing.name,
        pathParameters: {orderIdKeyname: orderResult.data!.orderId},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color continueChildColor = Color.fromARGB(255, 0, 122, 255);
    const double buttonContentHeight = 16;

    Widget loadingButttonChild = KeyedSubtree(
      key: const ValueKey('loading_button_animation'),
      child: LoadingAnimationWidget.dotsTriangle(
          color: continueChildColor, size: buttonContentHeight),
    );
    Widget defaultButtonChild = KeyedSubtree(
      key: const ValueKey('default_button_content'),
      child: Text(
        'Continue',
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontSize: buttonContentHeight,
              height: 1,
              color: continueChildColor,
              letterSpacing: 0,
            ),
      ),
    );

    Widget buttonContent =
        _isLoading ? loadingButttonChild : defaultButtonChild;

    return Container(
      color: const Color.fromARGB(255, 29, 39, 42),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            "Order total",
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            "Place your order with total of ${widget.totalPrice}${CurrencyHelper.getSymbol(widget.currency)}",
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return const Color.fromARGB(255, 200, 200, 200);
                    }
                    return null;
                  },
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
                padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.all(16)),
              ),
              onPressed: _isLoading ? null : _confirmOrder,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: buttonContent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
