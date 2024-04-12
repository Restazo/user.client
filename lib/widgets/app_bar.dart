import 'dart:ui';
import 'package:flutter/material.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DefaultAppBar({
    super.key,
    this.leftNavigationIconAsset,
    this.leftNavigationIconAction,
    this.rightNavigationIconAsset,
    this.rightNavigationIconAction,
    this.title,
  });

  final String? title;
  final String? leftNavigationIconAsset;
  final void Function()? leftNavigationIconAction;
  final String? rightNavigationIconAsset;
  final void Function()? rightNavigationIconAction;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: ClipRect(
        // Clip the widget to only apply effects within its bounds
        child: BackdropFilter(
          // Apply a filter to the background content
          filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0), // Blur effect
          child: AppBar(
            scrolledUnderElevation: 0.0,
            title: title != null
                ? Text(
                    title!,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                  )
                : null,
            backgroundColor:
                Theme.of(context).scaffoldBackgroundColor.withOpacity(0.0),
            centerTitle: true,
            leading: leftNavigationIconAction != null &&
                    leftNavigationIconAsset != null
                ? IconButton(
                    highlightColor: Theme.of(context).highlightColor,
                    onPressed: leftNavigationIconAction,
                    icon: Image.asset(
                      leftNavigationIconAsset!,
                      width: 28,
                      height: 28,
                    ),
                  )
                : null,
            actions: [
              if (rightNavigationIconAsset != null &&
                  rightNavigationIconAction != null)
                IconButton(
                  highlightColor: Theme.of(context).highlightColor,
                  onPressed: rightNavigationIconAction,
                  icon: Image.asset(
                    rightNavigationIconAsset!,
                    width: 28,
                    height: 28,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
