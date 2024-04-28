import 'package:flutter/material.dart';
import 'package:restazo_user_mobile/helpers/renavigations.dart';
import 'package:restazo_user_mobile/helpers/show_cupertino_dialog_with_three_actions.dart';
import 'package:restazo_user_mobile/models/ongoing_orders_at_table.dart';
import 'package:restazo_user_mobile/screens/waiter_mode/ongoing_orders.dart';
import 'package:restazo_user_mobile/widgets/buttom_sheet_with_menu_items.dart';

class TableWithOrders extends StatefulWidget {
  const TableWithOrders({
    super.key,
    required this.tableData,
    required this.onMark,
  });

  final OngoingOrder tableData;
  final Future<void> Function(String, MarkTableOrdersAs) onMark;

  @override
  State<TableWithOrders> createState() => _TableWithOrdersState();
}

class _TableWithOrdersState extends State<TableWithOrders> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.tableData.tableItems.isNotEmpty
          ? Colors.white
          : const Color.fromARGB(255, 29, 39, 42),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        splashColor: widget.tableData.tableItems.isNotEmpty
            ? Colors.black.withOpacity(0.1)
            : Colors.white.withOpacity(0.1),
        highlightColor: widget.tableData.tableItems.isNotEmpty
            ? Colors.black.withOpacity(0.1)
            : Colors.white.withOpacity(0.1),
        onTap: () {
          showModalBottomSheetWithMenuItems(
            context,
            "Items from table ${widget.tableData.tableLabel}",
            widget.tableData.tableItems,
            "Cancel",
            () {
              navigateBack(context);
            },
            "Complete",
            () {
              showCupertinoDialogWithThreeActions(
                  context,
                  "Mark table as",
                  "Mark this table ordered items as paid or unpaid",
                  "Paid",
                  () async {
                    if (mounted) {
                      navigateBack(context);
                      navigateBack(context);
                    }
                    await widget.onMark(
                        widget.tableData.tableId, MarkTableOrdersAs.paid);
                  },
                  "Unpaid",
                  () async {
                    if (mounted) {
                      navigateBack(context);
                      navigateBack(context);
                    }
                    await widget.onMark(
                        widget.tableData.tableId, MarkTableOrdersAs.unpaid);
                  },
                  "Cancel",
                  () {
                    navigateBack(context);
                  });
            },
          );
        },
        child: Stack(
          children: [
            Center(
              child: Text(
                widget.tableData.tableLabel,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: widget.tableData.tableItems.isNotEmpty
                        ? Colors.black
                        : Colors.white),
              ),
            ),
            Positioned(
              top: 12,
              left: 12,
              child: Text(
                "Table",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: widget.tableData.tableItems.isNotEmpty
                          ? Colors.black
                          : Colors.white,
                      fontSize: 12,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
