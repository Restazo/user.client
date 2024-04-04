import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:restazo_user_mobile/app_block/theme.dart';
import 'package:restazo_user_mobile/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load env variables
  await dotenv.load(fileName: ".env");

// Get the device secure storage
  const storage = FlutterSecureStorage();
  String? deviceId = await storage.read(key: "device_id");

  String initialRoute = deviceId != null ? '/restaurants' : '/';

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
