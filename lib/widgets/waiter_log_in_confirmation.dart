import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pinput/pinput.dart';

import 'package:restazo_user_mobile/app_block/pinput_themes.dart';
import 'package:restazo_user_mobile/env.dart';
import 'package:restazo_user_mobile/helpers/show_cupertino_dialog_with_one_action.dart';
import 'package:restazo_user_mobile/helpers/user_app_api.dart';
import 'package:restazo_user_mobile/router/app_router.dart';

class WaiterLogInConfirmation extends StatefulWidget {
  const WaiterLogInConfirmation({
    super.key,
    required this.waiterEmail,
  });

  final String waiterEmail;

  @override
  State<WaiterLogInConfirmation> createState() =>
      _WaiterLogInConfirmationState();
}

class _WaiterLogInConfirmationState extends State<WaiterLogInConfirmation> {
  bool _isLoading = false;
  bool forcePinErrorState = false;
  final TextEditingController _pinController = TextEditingController();
  final storage = const FlutterSecureStorage();

  @override
  void dispose() {
    _pinController.dispose();

    super.dispose();
  }

  Future<void> _confirmWaiterLogIn() async {
    setState(() {
      _isLoading = true;
    });

    final result = await APIService()
        .confirmLogInWaiter(widget.waiterEmail, _pinController.value.text);
    setState(() {
      _isLoading = false;
    });

    if (result.isSuccess) {
      await Future.wait([
        storage.write(key: accessTokenKeyName, value: result.data!.accessToken),
        storage.write(key: waiterEmailKeyName, value: result.data!.email),
        storage.write(key: waiterNameKeyName, value: result.data!.name),
      ]);

      if (mounted) {
        context.goNamed(
          ScreenNames.waiterHome.name,
          extra: {"fromConfirmed": true},
        );
      }
      return;
    }

    if (mounted) {
      _pinController.clear();
      showCupertinoDialogWithOneAction(
          context, "Fail", result.errorMessage!, "OK", () {
        context.pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color bodyChildColor = Color.fromARGB(255, 255, 255, 255);

    final double bodyContentHeight = defaultPinTheme.height!;

    Widget loadingBodyChild = KeyedSubtree(
      key: const ValueKey('loading_button_animation'),
      child: LoadingAnimationWidget.dotsTriangle(
          color: bodyChildColor, size: bodyContentHeight),
    );
    Widget defaultBodyChild = KeyedSubtree(
      key: const ValueKey('default_button_content'),
      child: Pinput(
        controller: _pinController,
        length: 5,
        defaultPinTheme: defaultPinTheme,
        errorPinTheme: errorPinTheme,
        focusedPinTheme: focusedPinTheme,
        submittedPinTheme: submittedPinTheme,
        pinAnimationType: PinAnimationType.fade,
        showCursor: false,
        errorText: 'Invalid pin code',
        forceErrorState: forcePinErrorState,
        onCompleted: (value) {
          if (_pinController.value.text.length != 5 ||
              !RegExp(r'^[0-9]+$').hasMatch(_pinController.value.text)) {
            setState(() {
              forcePinErrorState = true;
            });
          }
          if (forcePinErrorState) return;

          _confirmWaiterLogIn();
        },
        onChanged: (value) {
          if (forcePinErrorState) {
            setState(() {
              forcePinErrorState = false;
            });
          }
        },
        errorBuilder: (errorText, pin) {
          return Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Center(
              child: Text(
                errorText!,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: const Color.fromARGB(255, 255, 59, 47)),
              ),
            ),
          );
        },
        onTapOutside: (_) {
          FocusScope.of(context).unfocus();
        },
        separatorBuilder: (index) {
          return const SizedBox(width: 16);
        },
      ),
    );

    Widget bodyContent = _isLoading ? loadingBodyChild : defaultBodyChild;

    return Material(
      color: const Color.fromARGB(255, 29, 39, 42),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
              left: 32,
              right: 32,
              bottom: 32,
            ),
            child: Column(
              children: [
                Text(
                  'Please enter pin code sent to:',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        height: 1,
                        color: Colors.white,
                        letterSpacing: 0,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.waiterEmail,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        height: 1,
                        color: const Color.fromARGB(255, 189, 189, 189),
                        letterSpacing: 0,
                      ),
                ),
                const SizedBox(height: 24),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: bodyContent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
