import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restazo_user_mobile/helpers/renavigations.dart';
import 'package:restazo_user_mobile/models/order_menu_item.dart';
import 'package:restazo_user_mobile/widgets/app_bar.dart';

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

  @override
  Widget build(BuildContext context) {
    // state = ref.read(provider)
    return Scaffold(
      appBar: RestazoAppBar(
        leftNavigationIconAction: () => navigateBack(context),
        leftNavigationIconAsset: 'assets/left.png',
        title: "Confirm order",
      ),
    );
  }
}
