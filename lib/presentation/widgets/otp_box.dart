import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged; // Add onChanged parameter

  const OtpBox({super.key, required this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.1,
        height: MediaQuery.of(context).size.width * 0.2,
        child: TextFormField(
          controller: controller,
          onChanged: onChanged, // Pass onChanged callback to TextFormField
          style: Theme.of(context).textTheme.headlineMedium,
          keyboardType: TextInputType.number,
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
