import 'package:flutter/material.dart';

class PrimaryTextField extends StatelessWidget {
  final String hintText;
  final IconData? icon;
  final TextEditingController? controller;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool enabled;
  const PrimaryTextField({
    super.key,
    required this.hintText,
    this.icon,
    this.controller,
    this.obscureText = false,
    this.validator,
    this.keyboardType,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      enabled: enabled,
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: Icon(
          icon,
          color: Colors.grey,
        ),
      ),
    );
  }
}
