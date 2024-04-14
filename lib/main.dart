import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:restazo_user_mobile/app_block/theme.dart';
import 'package:restazo_user_mobile/helpers/env_check.dart';
import 'package:restazo_user_mobile/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load env variables
  await dotenv.load(fileName: ".env");
  checkEnv();

  // Get the device secure storage
  const storage = FlutterSecureStorage();
  // Get the device_id from the secure storage
  String? deviceId = await storage.read(key: dotenv.env['DEVICE_ID_KEY_NAME']!);

  String initialRoute = '/settings';
  // String initialRoute = deviceId != null ? '/' : '/init';

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((fn) {
    runApp(ProviderScope(
      child: App(initialRoute: initialRoute),
    ));
  });
}

class App extends StatelessWidget {
  const App({super.key, required this.initialRoute});

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: appTheme,
      routerConfig: AppRouter(initialLocation: initialRoute).router,
    );
  }
}
