import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:restazo_user_mobile/app_block/theme.dart';
import 'package:restazo_user_mobile/helpers/env_check.dart';
import 'package:restazo_user_mobile/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  checkEnv();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const ProviderScope(child: App()));
  });
}

class App extends StatelessWidget {
  const App({super.key});

  // final routeObserver = RouteObserver();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: appTheme,
      routerConfig: AppRouter().router,
    );
  }
}
