import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:restazo_user_mobile/env.dart';

import 'package:restazo_user_mobile/helpers/renavigations.dart';
import 'package:restazo_user_mobile/helpers/show_cupertino_dialog_with_one_action.dart';
import 'package:restazo_user_mobile/widgets/app_bar.dart';
import 'package:restazo_user_mobile/widgets/qr_scanner_overlay.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  MobileScannerController scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
  );
  bool _isLoading = false;
  bool _isScanned = false;
  Future<void>? _handleScanningFuture;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _validateQr(String qrValue) async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 300));

    scannerController.dispose();

    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      scannerController =
          MobileScannerController(detectionSpeed: DetectionSpeed.normal);
    });

    _isScanned = false;
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> handleDetection(Barcode capture) async {
    _isScanned = true;
    final barcodeValue = capture.rawValue;
    if (barcodeValue != null && barcodeValue.contains(userWebAppUrl)) {
      await _validateQr(barcodeValue);
    } else {
      showCupertinoDialogWithOneAction(
        context,
        "Invalid QR",
        "This QR code holds an invalid value for this application",
        "OK",
        () {
          _isScanned = false;
          navigateBack(context);
        },
      );
    }
  }

  @override
  void dispose() {
    scannerController.dispose();
    if (_handleScanningFuture != null) {
      _handleScanningFuture!.ignore();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget scannerWidget = KeyedSubtree(
      key: const ValueKey('scanner_widget'),
      child: MobileScanner(
        controller: scannerController,
        overlay: QRScannerOverlay(overlayColour: Colors.black.withOpacity(0.2)),
        onDetect: (capture) {
          if (_isScanned) return;
          final barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            _handleScanningFuture = handleDetection(barcodes.first);
          }
        },
      ),
    );

    Widget loaderWidget = KeyedSubtree(
      key: const ValueKey("scanner_loader"),
      child: Center(
        child:
            LoadingAnimationWidget.dotsTriangle(color: Colors.white, size: 48),
      ),
    );

    Widget bodyWidget = _isLoading ? loaderWidget : scannerWidget;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: RestazoAppBar(
        leftNavigationIconAsset: 'assets/left.png',
        leftNavigationIconAction: () => navigateBack(context),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: bodyWidget,
      ),
    );
  }
}
