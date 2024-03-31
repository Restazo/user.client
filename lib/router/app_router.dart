import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:restazo_user_mobile/screens/tabs.dart';

class AppRouter {
  AppRouter({required this.initialLocation});

  final String initialLocation;

  late final GoRouter router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/',
        name: 'init',
        builder: (context, state) => const InitScreen(),
      ),
      GoRoute(
        path: '/restaurants',
        name: 'restaurants',
        builder: (context, state) => const TabsScreen(),
      )
    ],
  );
}

// TODO: Delete this screen
class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  final storage = const FlutterSecureStorage();

  Future _continue() async {
    String deviceId = "your_generated_device_id";
    await storage.write(key: "device_id", value: deviceId);
    if (mounted) {
      context.goNamed("restaurants");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("hello"),
        actions: [
          IconButton(
            onPressed: _continue,
            icon: const Icon(Icons.golf_course),
          ),
        ],
      ),
    );
  }
}
