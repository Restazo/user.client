import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:restazo_user_mobile/providers/user_location_data_provider.dart';
import 'package:restazo_user_mobile/env.dart';

class RestazoSplashScreen extends ConsumerStatefulWidget {
  const RestazoSplashScreen({super.key});

  @override
  ConsumerState<RestazoSplashScreen> createState() =>
      _RestazoSplashScreenState();
}

class _RestazoSplashScreenState extends ConsumerState<RestazoSplashScreen> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _initAppData();
  }

  Future<void> _initAppData() async {
    const storage = FlutterSecureStorage();
    final prefs = await SharedPreferences.getInstance();

    bool interacted = prefs.getBool(interactedKeyName) ?? false;

    if (interacted) {
      String route = '/';

      await Future.wait(
        [
          Future.delayed(const Duration(seconds: 2)),
          ref.read(userLocationDataProvider.notifier).saveCurrentLocation(),
        ],
      );

      if (await storage.read(key: accessTokenKeyName) != null) {
        route = '/$waiterEndpoint';
      }

      if (mounted) {
        context.go(route);
      }
    } else {
      if (mounted) {
        context.go('/init');
      }
    }
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/app_icon/icon.png',
          width: 128,
          height: 128,
        ),
      ),
    );
  }
}
