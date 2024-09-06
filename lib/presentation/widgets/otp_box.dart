import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String>? onChanged;
  final TextInputAction textInputAction; // Added textInputAction

  const OtpBox({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.textInputAction, // Added to constructor
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.1,
        height: MediaQuery.of(context).size.width * 0.2,
        child: TextFormField(
          focusNode: focusNode,
          controller: controller,
          onChanged: onChanged,
          textInputAction: textInputAction, // Set textInputAction here
          style: Theme.of(context).textTheme.headlineMedium,
          keyboardType: TextInputType.number, // Ensures numeric keyboard
          textAlign: TextAlign.center,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
      ),
    );
  }
}
