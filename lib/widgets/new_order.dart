import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restazo_user_mobile/helpers/renavigations.dart';
import 'package:restazo_user_mobile/helpers/show_cupertino_dialog_with_three_actions.dart';

import 'package:restazo_user_mobile/models/waiter_request.dart';
import 'package:restazo_user_mobile/widgets/buttom_sheet_with_menu_items.dart';

enum PendingOrderAction {
  accept,
  decline,
}

class PendingOrderTile extends StatefulWidget {
  const PendingOrderTile(
      {super.key, required this.orderData, required this.onPressed});

  final PendingOrder orderData;
  final Future<void> Function(String, PendingOrderAction) onPressed;

  @override
  State<PendingOrderTile> createState() => _PendingOrderTileState();
}

class _PendingOrderTileState extends State<PendingOrderTile> {
  late StreamSubscription<int> _timerSubscription;
  late Stream<int> _timerStream;
  late DateTime _createdAtDateTime;

  @override
  void initState() {
    super.initState();
    _createdAtDateTime = DateTime.fromMillisecondsSinceEpoch(
        widget.orderData.createdAt,
        isUtc: true);

    _timerStream = Stream.periodic(const Duration(seconds: 5), (i) => i);

    _timerSubscription = _timerStream.listen((_) {
      // Update the UI
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Cancel the timer subscription when the widget is disposed
    _timerSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentUtcTime = DateTime.now().toUtc();
    Duration waitingDuration = currentUtcTime.difference(_createdAtDateTime);

    Color indicatorColor = const Color.fromARGB(255, 255, 59, 47);

    if (waitingDuration.inSeconds <= 60) {
      indicatorColor = Colors.white;
    } else if (waitingDuration.inMinutes <= 2) {
      indicatorColor = const Color.fromARGB(255, 248, 104, 0);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 80,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 29, 39, 42),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            color: Colors.black.withOpacity(0.25),
            blurRadius: 10,
            spreadRadius: 6,
          )
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Table ${widget.orderData.tableLabel} placed an order",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white, fontSize: 16),
                ),
                const Spacer(),
                Row(
                  children: [
                    Text(
                      "Waiting ",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: indicatorColor, fontSize: 16),
                    ),
                    Text(
                      "●",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: indicatorColor, fontSize: 16),
                    )
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {
              showModalBottomSheetWithMenuItems(
                context,
                "Order from table ${widget.orderData.tableLabel}",
                widget.orderData.orderItems,
                "Cancel",
                () {
                  navigateBack(context);
                },
                "Action",
                () {
                  showCupertinoDialogWithThreeActions(
                      context,
                      "Order action",
                      "Accept ot decline this order from table ${widget.orderData.tableLabel}",
                      "Accept",
                      () async {
                        if (mounted) {
                          navigateBack(context);
                          navigateBack(context);
                        }
                        await widget.onPressed(widget.orderData.orderId,
                            PendingOrderAction.accept);
                      },
                      "Decline",
                      () async {
                        if (mounted) {
                          navigateBack(context);
                          navigateBack(context);
                        }
                        await widget.onPressed(widget.orderData.orderId,
                            PendingOrderAction.decline);
                      },
                      "Cancel",
                      () {
                        navigateBack(context);
                      });
                },
              );
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 32, vertical: 30),
              ),
              backgroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10)))),
            ),
            child: Text(
              "Review",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: 20,
                    color: Colors.black,
                  ),
            ),
          )
        ],
      ),
    );
  }
}
