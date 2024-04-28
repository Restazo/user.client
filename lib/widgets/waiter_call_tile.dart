import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restazo_user_mobile/helpers/renavigations.dart';
import 'package:restazo_user_mobile/helpers/show_cupertino_dialog_with_two_actions.dart';
import 'package:restazo_user_mobile/models/waiter_request.dart';

class WaiterCallTile extends StatefulWidget {
  const WaiterCallTile(
      {super.key, required this.callData, required this.onPressed});

  final WaiterRequest callData;
  final Future<void> Function(String) onPressed;

  @override
  State<WaiterCallTile> createState() => _WaiterCallTileState();
}

class _WaiterCallTileState extends State<WaiterCallTile> {
  late StreamSubscription<int> _timerSubscription;
  late Stream<int> _timerStream;
  late DateTime _createdAtDateTime;

  @override
  void initState() {
    super.initState();
    _createdAtDateTime = DateTime.fromMillisecondsSinceEpoch(
        widget.callData.createdAt,
        isUtc: true);

    _timerStream = Stream.periodic(const Duration(seconds: 5), (i) => i);

    _timerSubscription = _timerStream.listen((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timerSubscription.cancel();
    super.dispose();
  }

  String formatWaitingTime(Duration waitingTime) {
    if (waitingTime.inSeconds + 3 < 60) {
      return "${waitingTime.inSeconds + 3}s";
    } else if (waitingTime.inMinutes < 60) {
      return "${waitingTime.inMinutes}m";
    } else {
      return "${waitingTime.inHours}h";
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentUtcTime = DateTime.now().toUtc();
    Duration waitingDuration = currentUtcTime.difference(_createdAtDateTime);
    String waitingTime = formatWaitingTime(waitingDuration);

    Color indicatorColor = const Color.fromARGB(255, 255, 59, 47);

    if (waitingDuration.inSeconds + 3 < 60) {
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
                  "Table ${widget.callData.tableLabel} ${widget.callData.requestType == 'waiter' ? "calls waiter" : "requests bill"}",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white, fontSize: 16),
                ),
                const Spacer(),
                Text(
                  "Waiting $waitingTime",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: indicatorColor, fontSize: 16),
                ),
              ],
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {
              showCupertinoDialogWithTwoActions(
                  context,
                  "Accept ${widget.callData.requestType == 'waiter' ? "waiter call" : "bill request"}",
                  "Accept ${widget.callData.requestType == 'waiter' ? "waiter call" : "bill request"} from table ${widget.callData.tableLabel}",
                  "Cancel",
                  () {
                    navigateBack(context);
                  },
                  "Accept",
                  () async {
                    if (mounted) {
                      navigateBack(context);
                    }
                    await widget.onPressed(widget.callData.tableId);
                  });
              // await widget.onPressed(widget.callData.tableId);
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
              "Accept",
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
