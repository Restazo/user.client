import 'package:flutter_riverpod/flutter_riverpod.dart';

class TopRightCornerContentState {
  final String asset;
  const TopRightCornerContentState({required this.asset});
}

class TopRightCornerContentNotifier
    extends StateNotifier<TopRightCornerContentState> {
  TopRightCornerContentNotifier()
      : super(
            const TopRightCornerContentState(asset: 'assets/qr-code-scan.png'));

  void updateTopRightCornerAsset(String asset) {
    state = TopRightCornerContentState(asset: asset);
  }
}

final topRightCornerContentProvider = StateNotifierProvider<
    TopRightCornerContentNotifier, TopRightCornerContentState>(
  (ref) => TopRightCornerContentNotifier(),
);
