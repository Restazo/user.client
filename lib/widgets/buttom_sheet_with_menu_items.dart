import 'package:flutter/material.dart';

import 'package:restazo_user_mobile/models/order_menu_item.dart';

void showModalBottomSheetWithMenuItems(
  BuildContext context,
  String title,
  List<OrderProcessingMenuItem>? menuItems,
  String? leftActionLabel,
  void Function()? leftAction,
  String? rightActionLabel,
  void Function()? rightAction,
) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  leftAction != null && leftActionLabel != null
                      ? TextButton(
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(75, 255, 255, 255)),
                          ),
                          onPressed: leftAction,
                          child: Text(
                            leftActionLabel,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Colors.white,
                                  fontSize: 16,
                                  height: 1,
                                ),
                          ),
                        )
                      : const SizedBox(
                          width: 64,
                        ),
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                            height: 1,
                          ),
                    ),
                  ),
                  rightAction != null && rightActionLabel != null
                      ? TextButton(
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(75, 255, 255, 255)),
                          ),
                          onPressed: rightAction,
                          child: Text(
                            rightActionLabel,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Colors.white,
                                  fontSize: 16,
                                  height: 1,
                                ),
                          ),
                        )
                      : const SizedBox(
                          width: 64,
                        ),
                ],
              ),
              Container(
                height: 0.2,
                width: double.infinity,
                color: const Color.fromARGB(255, 125, 125, 125),
              ),
              const SizedBox(height: 36),
              menuItems != null && menuItems.isNotEmpty
                  ? Flexible(
                      flex: 1,
                      child: ListView.builder(
                        itemCount: menuItems.length,
                        itemBuilder: (context, index) {
                          return buildMenuItemTile(context, menuItems[index]);
                        },
                      ),
                    )
                  : Text(
                      "No items",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                            height: 1,
                          ),
                    ),
              const SizedBox(height: 20)
            ],
          ));
    },
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: const Color.fromARGB(255, 29, 39, 42),
  );
}

Widget buildMenuItemTile(
    BuildContext context, OrderProcessingMenuItem itemData) {
  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
    ),
    child: Row(
      children: [
        Text(
          "${itemData.itemAmount} X ",
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: const Color.fromARGB(255, 0, 122, 255),
                fontSize: 16,
                height: 1,
              ),
        ),
        Expanded(
          child: Text(
            itemData.itemName,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Colors.black,
                  fontSize: 16,
                  height: 1,
                ),
          ),
        ),
      ],
    ),
  );
}
