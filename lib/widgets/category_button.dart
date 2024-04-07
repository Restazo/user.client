import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MenuCategoryButton extends StatelessWidget {
  const MenuCategoryButton({
    super.key,
    required this.isActive,
    required this.isLast,
    required this.isFirst,
    required this.categoryLabel,
    required this.index,
    required this.onSelectCategory,
  });

  final bool isActive;
  final bool isLast;
  final bool isFirst;
  final String categoryLabel;
  final int index;
  final void Function(int) onSelectCategory;

  void _selectCategory(int index) {
    onSelectCategory(index);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: !isLast && !isFirst
          ? const EdgeInsets.only(right: 8)
          : isFirst
              ? const EdgeInsets.only(right: 8, left: 16)
              : const EdgeInsets.only(right: 16),
      child: AnimatedContainer(
        margin: const EdgeInsets.symmetric(vertical: 8),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          boxShadow: [
            isActive
                ? BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 4,
                    spreadRadius: 4,
                  )
                : BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                  )
          ],
          color: isActive
              ? Colors.white.withOpacity(0.35)
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(50),
        ),
        child: TextButton(
          onPressed: () {
            _selectCategory(index);
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          child: Text(
            categoryLabel,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Colors.white,
                  height: 1,
                ),
          ),
        ),
      ),
    );
  }
}
