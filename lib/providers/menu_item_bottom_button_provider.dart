import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuItemButtonState {
  final String buttonLabel;
  const MenuItemButtonState({required this.buttonLabel});
}

class MenuItemButtonNotifier extends StateNotifier<MenuItemButtonState> {
  MenuItemButtonNotifier()
      : super(const MenuItemButtonState(buttonLabel: "Scan table QR"));

  void updateButtonLabel(String buttonLabel) {
    state = MenuItemButtonState(buttonLabel: buttonLabel);
  }
}

final menuItemButtonProvider =
    StateNotifierProvider<MenuItemButtonNotifier, MenuItemButtonState>(
  (ref) => MenuItemButtonNotifier(),
);
