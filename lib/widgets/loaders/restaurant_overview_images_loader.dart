import 'package:flutter/material.dart';

class RestaurntOverViewImagesLoader extends StatefulWidget {
  const RestaurntOverViewImagesLoader({super.key});

  @override
  State<RestaurntOverViewImagesLoader> createState() =>
      _RestaurntOverViewImagesLoaderState();
}

class _RestaurntOverViewImagesLoaderState
    extends State<RestaurntOverViewImagesLoader>
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
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                spreadRadius: 8,
                blurRadius: 10,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          margin: const EdgeInsets.only(bottom: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: AspectRatio(
              aspectRatio: 350 / 214,
              child: Container(
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
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
