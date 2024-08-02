import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DrawerTile extends StatelessWidget {
  final IconData? icon;
  final String title;
  final void Function()? onTap;
  const DrawerTile(
      {super.key, required this.icon, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.white,
            size: 30,
          ),
          title: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
