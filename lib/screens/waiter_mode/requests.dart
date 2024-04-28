import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restazo_user_mobile/helpers/renavigations.dart';
import 'package:restazo_user_mobile/helpers/show_cupertino_dialog_with_one_action.dart';
import 'package:restazo_user_mobile/helpers/user_app_api.dart';
import 'package:restazo_user_mobile/models/waiter_request.dart';
import 'package:restazo_user_mobile/providers/waiter_requests_provider.dart';
import 'package:restazo_user_mobile/strings.dart';
import 'package:restazo_user_mobile/widgets/error_widgets/error_screen.dart';
import 'package:restazo_user_mobile/widgets/new_order.dart';
import 'package:restazo_user_mobile/widgets/waiter_call_tile.dart';

class PendingRequestsScreen extends ConsumerStatefulWidget {
  const PendingRequestsScreen({super.key});

  @override
  ConsumerState<PendingRequestsScreen> createState() =>
      _PendingRequestsScreenState();
}

class _PendingRequestsScreenState extends ConsumerState<PendingRequestsScreen> {
  Future<void> acceptWaiterCall(String tableId) async {
    final acceptResult = await APIService().acceptRequest(tableId);

    if (!acceptResult.isSuccess) {
      if (mounted) {
        showCupertinoDialogWithOneAction(
            context, "Fail", acceptResult.errorMessage!, Strings.ok, () {
          if (mounted) {
            navigateBack(context);
          }
        });
      }
    } else {
      if (mounted) {
        showCupertinoDialogWithOneAction(
            context, "Success", acceptResult.data!.message, Strings.ok, () {
          if (mounted) {
            navigateBack(context);
          }
        });
      }
    }
  }

  Future<void> acceptOrDeclineOrder(
      String orderId, PendingOrderAction action) async {
    final result = await APIService().acceptOrDeclineOrder(orderId, action);

    if (!result.isSuccess) {
      if (mounted) {
        showCupertinoDialogWithOneAction(
            context, "Fail", result.errorMessage!, Strings.ok, () {
          if (mounted) {
            navigateBack(context);
          }
        });
      }
    } else {
      if (mounted) {
        showCupertinoDialogWithOneAction(
            context, "Success", result.data!.message, Strings.ok, () {
          if (mounted) {
            navigateBack(context);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Requests requestsState = ref.watch(waiterRequestsProvider);

    Widget content = KeyedSubtree(
      key: const ValueKey("waiter_requests_no_requests_ui"),
      child: ErrorScreenWithAction(
        baseMessageWidget: Center(
          child: Text(
            "No pending requests",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white),
          ),
        ),
      ),
    );

    if (requestsState.pendingOrders.isNotEmpty ||
        requestsState.waiterRequests.isNotEmpty) {
      content = KeyedSubtree(
        key: const ValueKey("waiter_requests_content_ui"),
        child: ListView.builder(
          itemCount: requestsState.pendingOrders.length +
              requestsState.waiterRequests.length,
          itemBuilder: (context, index) {
            if (index <= requestsState.pendingOrders.length - 1) {
              return PendingOrderTile(
                orderData: requestsState.pendingOrders[index],
                onPressed: acceptOrDeclineOrder,
              );
            }

            return WaiterCallTile(
              callData: requestsState
                  .waiterRequests[index - requestsState.pendingOrders.length],
              onPressed: acceptWaiterCall,
            );
          },
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: content,
      ),
    );
  }
}
