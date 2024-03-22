import 'package:flutter/material.dart';

import 'package:restazo_user_mobile/app_block/theme.dart';
import 'package:restazo_user_mobile/screens/location_view.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      home: LocationView(),
    );
  }
}
