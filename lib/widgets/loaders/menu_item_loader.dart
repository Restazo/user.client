import 'package:flutter/material.dart';

class MenuItemLoader extends StatefulWidget {
  const MenuItemLoader({super.key});

  @override
  State<MenuItemLoader> createState() => _MenuItemLoaderState();
}

class _MenuItemLoaderState extends State<MenuItemLoader>
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

  LinearGradient get gradient {
    return LinearGradient(
      begin: Alignment(_gradientAnimation.value - 1.0, 0),
      end: Alignment(_gradientAnimation.value, 0),
      colors: const [
        Color.fromARGB(25, 255, 255, 255),
        Color.fromARGB(50, 255, 255, 255),
        Color.fromARGB(25, 255, 255, 255),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 24,
        left: 20,
        right: 20,
        bottom: 36,
      ),
      child: Stack(
        children: [
          ListView(
            children: [
              AnimatedBuilder(
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
                            gradient: gradient,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              AnimatedBuilder(
                animation: _gradientAnimation,
                builder: (context, child) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: gradient,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 10,
                          spreadRadius: 6,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                  );
                },
              ),
              AnimatedBuilder(
                animation: _gradientAnimation,
                builder: (context, child) {
                  return Container(
                    height: 75,
                    decoration: BoxDecoration(
                      gradient: gradient,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 10,
                          spreadRadius: 6,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _gradientAnimation,
              builder: (context, child) {
                return Container(
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    gradient: gradient,
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
