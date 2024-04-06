import 'package:flutter/material.dart';

class ErrorScreenWithAction extends StatelessWidget {
  const ErrorScreenWithAction({
    super.key,
    required this.baseMessageWidget,
    this.buttonAction,
    this.errorMessage,
    this.buttonLabel,
  });

  final Widget baseMessageWidget;
  final String? errorMessage;
  final String? buttonLabel;
  final void Function()? buttonAction;

  @override
  Widget build(BuildContext context) {
    final Widget? errorMessageColumn = errorMessage != null
        ? Column(
            children: [
              const SizedBox(height: 36),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ],
          )
        : null;

    final Widget? actionColumn = buttonAction != null && buttonLabel != null
        ? Column(
            children: [
              const SizedBox(height: 12),
              TextButton(
                onPressed: buttonAction,
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.black), // Change text color
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.white), // Change background color
                  overlayColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      return const Color.fromARGB(255, 200, 200, 200);
                    },
                  ),
                ),
                child: Text(
                  buttonLabel!,
                  style: Theme.of(context).textTheme.bodyMedium!,
                ),
              ),
            ],
          )
        : null;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        baseMessageWidget,
        if (errorMessageColumn != null) errorMessageColumn,
        if (actionColumn != null) actionColumn,
      ],
    );
  }
}
