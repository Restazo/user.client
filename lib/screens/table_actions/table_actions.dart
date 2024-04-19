import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:restazo_user_mobile/helpers/renavigations.dart';

import 'package:restazo_user_mobile/helpers/show_cupertino_dialog_with_two_actions.dart';
import 'package:restazo_user_mobile/strings.dart';
import 'package:restazo_user_mobile/widgets/app_bar.dart';

class TableActionsScreen extends StatefulWidget {
  const TableActionsScreen({super.key});

  @override
  State<TableActionsScreen> createState() => _TableActionsScreenState();
}

class _TableActionsScreenState extends State<TableActionsScreen> {
  bool _isInitialised = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialised) {
      _isInitialised = true;
      _validateTableHash();
    }
  }

  void _validateTableHash() {
    final parameters = GoRouterState.of(context).pathParameters;
    print(parameters);
  }

  void _goBack() {
    navigateBack(context);
  }

  void showDialog() {
    showCupertinoDialogWithTwoActions(
        context,
        Strings.confirmationTitle,
        Strings.confirmToLeaveTableActions,
        Strings.cancel,
        _goBack,
        Strings.confirmTitle, () {
      _goBack();
      _goBack();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RestazoAppBar(
        title: Strings.tableActionsTitle,
        leftNavigationIconAction: showDialog,
        leftNavigationIconAsset: 'assets/left.png',
      ),
    );
  }
}
