import 'package:flutter/material.dart';

class RestaurantOverviewTextDataLoader extends StatefulWidget {
  const RestaurantOverviewTextDataLoader({super.key});

  @override
  State<RestaurantOverviewTextDataLoader> createState() =>
      _RestaurantOverviewTextDataLoaderState();
}

class _RestaurantOverviewTextDataLoaderState
    extends State<RestaurantOverviewTextDataLoader>
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
    return AnimatedBuilder(
      animation: _gradientAnimation,
      builder: (context, child) {
        return Container(
          height: 150,
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              // color: Colors.white.withOpacity(0.1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 10,
                  spreadRadius: 6,
                  offset: const Offset(0, 4),
                )
              ],
              gradient: LinearGradient(
                begin: Alignment(_gradientAnimation.value - 1.0, 0),
                end: Alignment(_gradientAnimation.value, 0),
                colors: const [
                  Color.fromARGB(25, 255, 255, 255),
                  Color.fromARGB(50, 255, 255, 255),
                  Color.fromARGB(25, 255, 255, 255),
                ],
              )),
          child: Column(
            children: [
              const Spacer(),
              Container(
                height: 75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  // color: Colors.white.withOpacity(0.1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0),
                      blurRadius: 8,
                      offset: const Offset(0, -4),
                    )
                  ],
                  gradient: LinearGradient(
                    begin: Alignment(_gradientAnimation.value - 1.0, 0),
                    end: Alignment(_gradientAnimation.value, 0),
                    colors: const [
                      Color.fromARGB(10, 255, 255, 255),
                      Color.fromARGB(20, 255, 255, 255),
                      Color.fromARGB(10, 255, 255, 255),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
