import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restazo_user_mobile/helpers/check_location_permissions.dart';
import 'package:restazo_user_mobile/helpers/renavigations.dart';
import 'package:restazo_user_mobile/helpers/show_cupertino_dialog_with_one_action.dart';

import 'package:restazo_user_mobile/helpers/show_cupertino_dialog_with_two_actions.dart';
import 'package:restazo_user_mobile/router/app_router.dart';
import 'package:restazo_user_mobile/strings.dart';
import 'package:restazo_user_mobile/widgets/app_bar.dart';

class TableActionsScreen extends StatefulWidget {
  const TableActionsScreen({super.key});

  @override
  State<TableActionsScreen> createState() => _TableActionsScreenState();
}

class _TableActionsScreenState extends State<TableActionsScreen> {
  @override
  void initState() {
    super.initState();
    _ensureLocationPermissions();
  }

  Future<void> _ensureLocationPermissions() async {
    final granted = await checkLocationPermissions();

    if (!granted) {
      if (mounted) {
        return showCupertinoDialogWithOneAction(
            context,
            Strings.lackOfPermissionsTitle,
            Strings.enableLocationMessage,
            Strings.ok, () {
          navigateBack(context);
          navigateBack(context);
        });
      }
    }
  }

  void _goBack() {
    navigateBack(context);
  }

  void showExitDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            Strings.confirmationTitle,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
          ),
          content: Text(
            Strings.confirmToLeaveTableActions,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Colors.black,
                ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                _goBack();
                _goBack();
              },
              child: Text(
                "End",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.black),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () {
                // TODO: clear the sesson access token

                _goBack();
                _goBack();
              },
              child: Text(
                "Pause",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.black),
              ),
            ),
            CupertinoDialogAction(
              onPressed: _goBack,
              child: Text(
                Strings.cancel,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  void _requestTheBill() {
    showCupertinoDialogWithTwoActions(
      context,
      Strings.requestTheBillTitle,
      Strings.confirmationMessageOnRequestBill,
      Strings.cancel,
      _goBack,
      Strings.confirmTitle,
      () {
        _goBack();
      },
    );
  }

  void _callWaiter() {
    showCupertinoDialogWithTwoActions(
      context,
      Strings.callWaitertitle,
      Strings.confirmationMessageOnCallWaiter,
      Strings.cancel,
      _goBack,
      Strings.confirmTitle,
      () {
        _goBack();
      },
    );
  }

  void _placeAnOrder() {
    context.goNamed(ScreenNames.placeOrder.name);
  }

  // UI methods
  Widget _buildCenteredText(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          textAlign: TextAlign.center,
          text,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Colors.black,
                fontSize: 32,
                height: 1,
              ),
        ),
      ),
    );
  }

  Widget _buildBox({
    required String text,
    int? flex,
    required void Function() onTap,
  }) {
    return Expanded(
      flex: flex ?? 1,
      child: Material(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        child: InkWell(
          splashFactory: NoSplash.splashFactory,
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return const Color.fromARGB(255, 200, 200, 200);
              }
              return null;
            },
          ),
          child: _buildCenteredText(text),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RestazoAppBar(
        title: Strings.tableActionsTitle,
        leftNavigationIconAction: showExitDialog,
        leftNavigationIconAsset: 'assets/left.png',
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
            child: Column(
              children: [
                Expanded(
                  flex: 390,
                  child: Row(
                    children: [
                      _buildBox(
                        text: Strings.requestTheBillTitle,
                        onTap: _requestTheBill,
                      ),
                      const SizedBox(width: 12),
                      _buildBox(
                        text: Strings.callWaitertitle,
                        onTap: _callWaiter,
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _buildBox(
                  text: Strings.placeAnOrderTitle,
                  flex: 294,
                  onTap: _placeAnOrder,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
