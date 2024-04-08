import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restazo_user_mobile/models/device_id.dart';
import 'package:restazo_user_mobile/helpers/api_result.dart';

class DeviceIdState extends APIServiceResult<DeviceId> {
  const DeviceIdState({super.data, super.errorMessage});
}
class LocationView extends StatefulWidget {
  const LocationView({super.key});

  @override
  State<LocationView> createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  final storage = const FlutterSecureStorage();

  Future _continue() async {
    String deviceId = "your_generated_device_id";
    await storage.write(key: "deviceId", value: deviceId);
    if (mounted) {
      context.goNamed("restaurants");
    }
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    String content,
    String imagePath,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Image.asset(
              imagePath,
              height: 16,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.white,
                  ),
            )
          ],
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Colors.white,
              ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 4, 15, 18),
        title: Text(
          "Your Location",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 12, left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Center(
                child: AspectRatio(
                  aspectRatio: 350 / 239,
                  child: Image.asset('assets/pic.jpg', fit: BoxFit.cover),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 36, left: 28, right: 28),
              child: Column(
                children: [
                  Text(
                    'Welcome to Restazo!',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                      context,
                      'Location Access',
                      'Location only used when the app is open for feature enhancement',
                      'assets/magic-wand.png'),
                  const SizedBox(height: 24),
                  _buildSection(
                      context,
                      'Privacy First',
                      'No background tracking. Your location helps us tailor the app\'s features to you',
                      'assets/shield.png'),
                  const SizedBox(height: 24),
                  _buildSection(
                      context,
                      'Secure',
                      'No data collection or sharing. Your privacy is our priority',
                      'assets/padlock.png'),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 56),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _continue,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 242, 242, 242),
                    elevation: 0,
                  ),
                  child: Text(
                    'Continue',
                    style:
                        GoogleFonts.istokWeb(fontSize: 16, color: Colors.black),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
