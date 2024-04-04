import 'package:flutter/material.dart';

class MenuSectionLoader extends StatefulWidget {
  const MenuSectionLoader({super.key});

  @override
  State<MenuSectionLoader> createState() => _MenuSectionLoaderState();
}

class _MenuSectionLoaderState extends State<MenuSectionLoader>
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
    return Column(
      children: [
        AnimatedBuilder(
          animation: _gradientAnimation,
          builder: (context, child) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: gradient,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 8,
                    spreadRadius: 6,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
            );
          },
        ),
        ...List.generate(
          3,
          (index) {
            return AnimatedBuilder(
              animation: _gradientAnimation,
              builder: (context, child) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  height: 96,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: gradient,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            spreadRadius: 6,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
