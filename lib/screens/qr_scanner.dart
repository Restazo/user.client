import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:restazo_user_mobile/env.dart';

import 'package:restazo_user_mobile/helpers/renavigations.dart';
import 'package:restazo_user_mobile/helpers/show_cupertino_dialog_with_one_action.dart';
import 'package:restazo_user_mobile/router/app_router.dart';
import 'package:restazo_user_mobile/strings.dart';
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
  bool _isScanned = false;

  @override
  void initState() {
    super.initState();
  }

  void handleDetection(Barcode capture) {
    _isScanned = true;
    final String? barcodeValue = capture.rawValue;
    if (barcodeValue != null &&
        barcodeValue.contains('$userWebAppUrl/$tableEndpoint/')) {
      final tableHash = barcodeValue.split('/')[4];

      context.goNamed(ScreenNames.tableActions.name,
          pathParameters: {tableHashParamName: tableHash});
    } else {
      showCupertinoDialogWithOneAction(
        context,
        Strings.invalidQrTitle,
        Strings.invalidQrMessage,
        Strings.ok,
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

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: RestazoAppBar(
        leftNavigationIconAsset: 'assets/left.png',
        leftNavigationIconAction: () => navigateBack(context),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: MobileScanner(
          controller: scannerController,
          overlay:
              QRScannerOverlay(overlayColour: Colors.black.withOpacity(0.2)),
          onDetect: (capture) {
            if (_isScanned) return;
            final barcodes = capture.barcodes;
            if (barcodes.isNotEmpty) {
              handleDetection(barcodes.first);
            }
          },
        ),
      ),
    );
  }
}
