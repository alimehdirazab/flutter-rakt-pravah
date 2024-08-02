import 'package:flutter/material.dart';
import 'package:rakt_pravah/core/ui.dart';

class PrimaryButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  const PrimaryButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      ),
      child: Text(
        text,
        style: TextStyles.body3.copyWith(color: Colors.white),
      ),
    );
  }
}
