import 'package:flutter/material.dart';
import 'package:restazo_user_mobile/helpers/renavigations.dart';
import 'package:restazo_user_mobile/widgets/app_bar.dart';

class NotExistingScreen extends StatefulWidget {
  const NotExistingScreen({super.key});

  @override
  State<NotExistingScreen> createState() => _NotExistingScreenState();
}

class _NotExistingScreenState extends State<NotExistingScreen> {
  void _navigateBack() {
    navigateBack(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RestazoAppBar(
        leftNavigationIconAsset: 'assets/left.png',
        leftNavigationIconAction: _navigateBack,
      ),
      body: Center(
        child: Text(
          "This screen does not yet exist",
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
