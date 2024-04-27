import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaceOrderButtonState {
  final String buttonLabel;
  const PlaceOrderButtonState({required this.buttonLabel});
}

class PlaceOrderButtonnotifier extends StateNotifier<PlaceOrderButtonState> {
  PlaceOrderButtonnotifier()
      : super(const PlaceOrderButtonState(buttonLabel: "Place an order"));

  void updateButtonLabel(String buttonLabel) {
    state = PlaceOrderButtonState(buttonLabel: buttonLabel);
  }
}

final placeOrderButtonProvider =
    StateNotifierProvider<PlaceOrderButtonnotifier, PlaceOrderButtonState>(
  (ref) => PlaceOrderButtonnotifier(),
);
