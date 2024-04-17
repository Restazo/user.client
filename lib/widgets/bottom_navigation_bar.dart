import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RestazoBottomNavigationBar extends StatefulWidget {
  const RestazoBottomNavigationBar({
    super.key,
    required this.leftItemAsset,
    required this.leftItemLabel,
    required this.rightItemAsset,
    required this.rightItemLabel,
    required this.selectScreen,
  });

  final String leftItemAsset;
  final String leftItemLabel;
  final String rightItemAsset;
  final String rightItemLabel;
  final void Function(int) selectScreen;

  @override
  State<RestazoBottomNavigationBar> createState() =>
      _RestazoBottomNavigationBarState();
}

class _RestazoBottomNavigationBarState extends State<RestazoBottomNavigationBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _tabSwitchButtonAnimationController;
  int _selectedPageIndex = 0;

  @override
  void initState() {
    super.initState();

    _tabSwitchButtonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    // Stop and dispose all the animation controllers
    _tabSwitchButtonAnimationController.stop();
    _tabSwitchButtonAnimationController.dispose();
    super.dispose();
  }

  void _selectScreen(int index) {
    // Run the tab item animation only if it is not active
    if (_selectedPageIndex != index) {
      _tabSwitchButtonAnimationController.forward(from: 0.0);
    }

    widget.selectScreen(index);

    setState(() {
      _selectedPageIndex = index;
    });

    // Give some light haptic feedback
    HapticFeedback.lightImpact();
  }

  BottomNavigationBarItem createBottomNavItem({
    required String iconPath,
    required String label,
    required bool isSelected,
  }) {
    return BottomNavigationBarItem(
      icon: AnimatedBuilder(
        animation: _tabSwitchButtonAnimationController,
        builder: (context, _) {
          final double yOffset = isSelected
              ? Tween<double>(begin: 0.0, end: -7.0)
                      .animate(
                        CurvedAnimation(
                          parent: _tabSwitchButtonAnimationController,
                          curve: Curves.easeOut,
                        ),
                      )
                      .value *
                  (1 - _tabSwitchButtonAnimationController.value) *
                  2
              : 0.0;

          return Transform.translate(
            offset: Offset(0, yOffset),
            child: Image.asset(
              iconPath,
              width: 28,
              height: 28,
              color: isSelected
                  ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor
                  : Theme.of(context)
                      .bottomNavigationBarTheme
                      .unselectedItemColor,
            ),
          );
        },
      ),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(62, 15, 34, 40),
            Color.fromARGB(200, 14, 35, 42),
            Color.fromARGB(245, 16, 30, 35),
            Color.fromARGB(255, 19, 31, 35),
            Color.fromARGB(255, 22, 32, 35),
          ],
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          // Override the canvas color to transparent to let the gradient show through
          canvasColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          onTap: _selectScreen,
          currentIndex: _selectedPageIndex,
          items: [
            createBottomNavItem(
              iconPath: widget.leftItemAsset,
              label: widget.leftItemLabel,
              isSelected: _selectedPageIndex == 0,
            ),
            createBottomNavItem(
              iconPath: widget.rightItemAsset,
              label: widget.rightItemLabel,
              isSelected: _selectedPageIndex == 1,
            ),
          ],
        ),
      ),
    );
  }
}
