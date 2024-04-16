import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pinput/pinput.dart';

import 'package:restazo_user_mobile/app_block/pinput_themes.dart';
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
  String waiterPin = '';

  Future<void> _confirmWaiterLogIn() async {
    setState(() {
      _isLoading = true;
    });

    final result =
        await APIService().confirmLogInWaiter(widget.waiterEmail, waiterPin);
    setState(() {
      _isLoading = false;
    });

    if (result.isSuccess) {
      if (mounted) {
        context.goNamed(
          ScreenNames.waiterHome.name,
          extra: {"fromConfirmed": true},
        );
      }
      return;
    }

    if (mounted) {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(
              "Fail",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            content: Text(
              result.errorMessage!,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.black,
                  ),
            ),
            actions: [
              CupertinoDialogAction(
                child: Text(
                  "OK",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.black),
                ),
                onPressed: () {
                  context.pop();
                },
              )
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color continueChildColor = Color.fromARGB(255, 0, 122, 255);

    const double buttonContentHeight = 16;

    Widget loadingButttonChild = KeyedSubtree(
      key: const ValueKey('loading_button_animation'),
      child: LoadingAnimationWidget.dotsTriangle(
          color: continueChildColor, size: buttonContentHeight),
    );
    Widget defaultButtonChild = KeyedSubtree(
      key: const ValueKey('default_button_content'),
      child: Text(
        'Continue',
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontSize: buttonContentHeight,
              height: 1,
              color: continueChildColor,
              letterSpacing: 0,
            ),
      ),
    );

    Widget buttonContent =
        _isLoading ? loadingButttonChild : defaultButtonChild;

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
                Pinput(
                  length: 5,
                  defaultPinTheme: defaultPinTheme,
                  errorPinTheme: errorPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                  pinAnimationType: PinAnimationType.fade,
                  obscureText: true,
                  obscuringCharacter: '●',
                  showCursor: false,
                  errorText: 'Invalid pin code',
                  forceErrorState: forcePinErrorState,
                  onChanged: (value) {
                    waiterPin = value;
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
                              .copyWith(
                                  color:
                                      const Color.fromARGB(255, 255, 59, 47)),
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
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return const Color.fromARGB(255, 200, 200, 200);
                    }
                    return null;
                  },
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
                padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.all(16)),
              ),
              onPressed: !_isLoading
                  ? () {
                      if (waiterPin.length != 5 ||
                          !RegExp(r'^[0-9]+$').hasMatch(waiterPin)) {
                        setState(() {
                          forcePinErrorState = true;
                        });
                      }
                      if (forcePinErrorState) return;

                      _confirmWaiterLogIn();
                    }
                  : null,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: buttonContent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
