import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restazo_user_mobile/helpers/renavigations.dart';
import 'package:restazo_user_mobile/helpers/show_cupertino_dialog_with_one_action.dart';
import 'package:restazo_user_mobile/helpers/user_app_api.dart';
import 'package:restazo_user_mobile/models/ongoing_orders_at_table.dart';
import 'package:restazo_user_mobile/providers/waiter_ongoing_order_provider.dart';
import 'package:restazo_user_mobile/strings.dart';
import 'package:restazo_user_mobile/widgets/error_widgets/error_screen.dart';
import 'package:restazo_user_mobile/widgets/table_with_ordered_items.dart';

enum MarkTableOrdersAs {
  paid,
  unpaid,
}

class OngoingOrdersScreen extends ConsumerStatefulWidget {
  const OngoingOrdersScreen({super.key});

  @override
  ConsumerState<OngoingOrdersScreen> createState() =>
      _OngoingOrdersScreenState();
}

class _OngoingOrdersScreenState extends ConsumerState<OngoingOrdersScreen> {
  Future<void> markTableOrders(String tableId, MarkTableOrdersAs action) async {
    final result = await APIService().markTableOrders(tableId, action);

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
    final List<OngoingOrder> ongoingOrdersState =
        ref.watch(ongoingOrdersProvider);

    Widget content = KeyedSubtree(
      key: const ValueKey("ongoing_orders_no_tables_ui"),
      child: ErrorScreenWithAction(
        baseMessageWidget: Center(
          child: Text(
            "No tables",
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white),
          ),
        ),
      ),
    );

    if (ongoingOrdersState.isNotEmpty) {
      content = KeyedSubtree(
        key: const ValueKey("ongoing_orders_content_tables_ui"),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 165 / 100,
          ),
          itemCount: ongoingOrdersState.length,
          itemBuilder: (context, index) {
            return TableWithOrders(
              tableData: ongoingOrdersState[index],
              onMark: markTableOrders,
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
