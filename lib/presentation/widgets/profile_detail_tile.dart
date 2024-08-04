import 'package:flutter/material.dart';
import 'package:rakt_pravah/presentation/widgets/gap_widget.dart';

class ProfileDetailTile extends StatelessWidget {
  final String title;
  final String subtitle;
  const ProfileDetailTile(
      {super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.grey),
        ),
        const GapWidget(size: -10),
        Text(subtitle)
      ],
    );
  }
}
