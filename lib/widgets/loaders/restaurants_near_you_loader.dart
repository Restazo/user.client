import 'package:flutter/material.dart';

class RestaurantsNearYouLoader extends StatefulWidget {
  const RestaurantsNearYouLoader({super.key});

  @override
  State<RestaurantsNearYouLoader> createState() =>
      _RestaurantsNearYouLoaderState();
}

class _RestaurantsNearYouLoaderState extends State<RestaurantsNearYouLoader>
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
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (_, index) {
        return AnimatedBuilder(
          animation: _gradientAnimation,
          builder: (context, child) {
            return Container(
              height: 128,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment(_gradientAnimation.value - 1.0, 0),
                  end: Alignment(_gradientAnimation.value, 0),
                  colors: const [
                    Color.fromARGB(25, 255, 255, 255),
                    Color.fromARGB(50, 255, 255, 255),
                    Color.fromARGB(25, 255, 255, 255),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 6,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
