import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restazo_user_mobile/helpers/renavigations.dart';
import 'package:restazo_user_mobile/providers/menu_item_provider.dart';
import 'package:restazo_user_mobile/widgets/app_bar.dart';

class MenuItemScreen extends ConsumerStatefulWidget {
  const MenuItemScreen({super.key});

  @override
  ConsumerState<MenuItemScreen> createState() => _MenuItemScreenState();
}

class _MenuItemScreenState extends ConsumerState<MenuItemScreen> {
  bool _isLoading = false;
  bool _screenInitialised = false;
  late Future<void> _loadMenuItemDataFuture;

  @override
  void initState() {
    super.initState();
    // ref.read(provider)
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_screenInitialised) {
      _loadMenuItemDataFuture = _loadMenuItemData();
      _screenInitialised = true;
    }
  }

  @override
  void dispose() {
    _loadMenuItemDataFuture.ignore();
    super.dispose();
  }

  Future<void> _loadMenuItemData() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    final menuItemDataState = ref.watch(menuItemProvider);

    if (menuItemDataState.initailMenuItemData == null) {
      // Request an API here
      await Future.delayed(const Duration(seconds: 2));
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateBack() {
    ref.read(menuItemProvider.notifier).leaveMenuItemScreen();
    navigateBack(context);
  }

  void _openQrScanner() {
    openQrScanner(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: DefaultAppBar(
        leftNavigationIconAsset: 'assets/left.png',
        leftNavigationIconAction: _navigateBack,
        rightNavigationIconAsset: 'assets/qr-code-scan.png',
        rightNavigationIconAction: _openQrScanner,
      ),
      body: ListView(
        children: [
          Text(
            'hello',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Colors.white),
          )
        ],
      ),
    );
  }
}
