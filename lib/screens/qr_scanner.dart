import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
  bool _isLoading = false;
  Future<void>? _startSessionFuture;

  @override
  void initState() {
    super.initState();
  }

  void handleDetection(Barcode capture) {
    _isScanned = true;
    final String? barcodeValue = capture.rawValue;
    if (barcodeValue != null &&
        barcodeValue.contains('$userWebAppUrl/$tableEndpoint/')) {
      final tableHash = barcodeValue.split('/$tableEndpoint/')[1];

      _startSessionFuture = _startTableSession(tableHash);
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

  Future<void> _startTableSession(String tableHash) async {
    setState(() {
      _isLoading = true;
    });

    // TODO: call an api to start the session here
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      context.goNamed(ScreenNames.tableActions.name);
    }
    _isScanned = false;

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    scannerController.dispose();
    if (_startSessionFuture != null) {
      _startSessionFuture!.ignore();
    }

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
      body: Stack(
        children: [
          MobileScanner(
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
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _isLoading
                ? Container(
                    width: double.infinity,
                    color: Colors.black.withOpacity(0.75),
                    child: Center(
                      child: LoadingAnimationWidget.dotsTriangle(
                          color: Colors.white, size: 48),
                    ),
                  )
                : null,
          )
        ],
      ),
    );
  }
}
