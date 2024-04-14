import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pinput/pinput.dart';

class WaiterLogInPopUp extends StatefulWidget {
  const WaiterLogInPopUp({super.key});

  @override
  State<WaiterLogInPopUp> createState() => _WaiterLogInPopUpState();
}

class _WaiterLogInPopUpState extends State<WaiterLogInPopUp> {
  String waiterEmail = '';
  String waiterPin = '';
  bool forcePinErrorState = false;
  bool emailInvalid = false;
  Color emailInputBorderColor = const Color.fromARGB(255, 107, 114, 116);

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 45,
      height: 45,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Colors.white,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 107, 114, 116),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(
        color: Colors.white,
        width: 2,
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Colors.white),
    );
    final errorPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromARGB(255, 255, 59, 47)),
    );

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
                        emailInputBorderColor =
                            const Color.fromARGB(255, 107, 114, 116);
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
                          color: emailInputBorderColor,
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
                    if (forcePinErrorState) {
                      setState(() {
                        forcePinErrorState = false;
                      });
                    }
                  },
                  onCompleted: (value) {
                    waiterPin = value;
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
                    const EdgeInsets.all(12)),
              ),
              onPressed: () {
                if (waiterPin.length != 5 ||
                    !RegExp(r'^[0-9]+$').hasMatch(waiterPin)) {
                  setState(() {
                    forcePinErrorState = true;
                  });
                }
                setState(() {
                  emailInvalid = true;
                  emailInputBorderColor =
                      const Color.fromARGB(255, 255, 59, 47);
                });
                print(waiterEmail);
                print(waiterPin);
              },
              child: Text(
                'Continue',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: const Color.fromARGB(255, 0, 122, 255),
                      letterSpacing: 0,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
