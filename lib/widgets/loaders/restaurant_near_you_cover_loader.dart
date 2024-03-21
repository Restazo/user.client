import 'package:flutter/material.dart';

class RestaurantNearYouCoverLoader extends StatefulWidget {
  const RestaurantNearYouCoverLoader({super.key});

  @override
  State<RestaurantNearYouCoverLoader> createState() =>
      _RestaurantNearYouCoverLoaderState();
}

class _RestaurantNearYouCoverLoaderState
    extends State<RestaurantNearYouCoverLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _gradientAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat(reverse: false);
    _gradientAnimation =
        Tween<double>(begin: -1.0, end: 2.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 128,
      width: 128,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment(_gradientAnimation.value - 0.5, 0),
          end: Alignment(_gradientAnimation.value, 0),
          colors: const [
            Color.fromARGB(25, 255, 255, 255),
            Color.fromARGB(255, 255, 255, 255),
            Color.fromARGB(25, 255, 255, 255),
          ],
        ),
      ),
    );
  }
}
