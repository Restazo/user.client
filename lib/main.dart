import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:restazo_user_mobile/env.dart';
import 'package:restazo_user_mobile/app_block/theme.dart';
import 'package:restazo_user_mobile/helpers/env_check.dart';
import 'package:restazo_user_mobile/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  checkEnv();

  const storage = FlutterSecureStorage();
  final prefs = await SharedPreferences.getInstance();
  bool interacted = prefs.getBool(interactedKeyName) ?? false;

  String initialRoute = interacted ? '/' : '/init';

  if (await storage.read(key: accessTokenKeyName) != null) {
    initialRoute = '/$waiterEndpoint';
  }

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
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
