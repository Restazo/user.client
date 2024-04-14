import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pinput/pinput.dart';

import 'package:restazo_user_mobile/app_block/pinput_themes.dart';

class WaiterLogInPopUp extends StatefulWidget {
  const WaiterLogInPopUp({
    super.key,
    required this.submitWaiterLogIn,
  });

  final Future<void> Function(String, String) submitWaiterLogIn;

  @override
  State<WaiterLogInPopUp> createState() => _WaiterLogInPopUpState();
}

class _WaiterLogInPopUpState extends State<WaiterLogInPopUp> {
  late String waiterEmail = '';
  String waiterPin = '';
  bool forcePinErrorState = false;
  bool emailInvalid = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _submitWaiterLogIn() async {
    setState(() {
      _isLoading = true;
    });

    await widget.submitWaiterLogIn(waiterEmail, waiterPin);

    setState(() {
      _isLoading = false;
    });
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
                  'Waiter mode log in',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                        letterSpacing: 0,
                      ),
                ),
                const SizedBox(height: 24),
                AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  alignment: Alignment.topCenter,
                  curve: Curves.easeIn,
                  child: TextField(
                    onTapOutside: (_) {
                      FocusScope.of(context).unfocus();
                    },
                    onChanged: (value) {
                      setState(() {
                        emailInvalid = false;
                      });
                      waiterEmail = value;
                    },
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Colors.white,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    decoration: InputDecoration(
                      helperMaxLines: 1,
                      helperStyle:
                          Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: const Color.fromARGB(255, 255, 59, 47),
                              ),
                      helperText: emailInvalid ? 'Invalid email' : null,
                      labelText: "Email",
                      labelStyle: const TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: emailInvalid
                              ? const Color.fromARGB(255, 255, 59, 47)
                              : const Color.fromARGB(255, 107, 114, 116),
                          width: 1,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                      contentPadding: const EdgeInsets.only(
                        top: 12,
                        bottom: 12,
                        left: 24,
                        right: 8,
                      ),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp('[\\s]')),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
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
                    return const SizedBox(
                      width: 16,
                    );
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
                      if (waiterEmail.isEmpty ||
                          !EmailValidator.validate(waiterEmail)) {
                        setState(() {
                          emailInvalid = true;
                        });
                      }

                      if (emailInvalid || forcePinErrorState) return;

                      _submitWaiterLogIn();
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
