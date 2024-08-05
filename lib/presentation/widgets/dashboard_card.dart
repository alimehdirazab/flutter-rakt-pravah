import 'package:flutter/material.dart';
import 'package:rakt_pravah/presentation/widgets/gap_widget.dart';

class DashboardCard extends StatelessWidget {
  final String image;
  final String title;
  final void Function()? onTap;
  const DashboardCard({
    super.key,
    required this.image,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.42,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(
                width: 65,
                height: 60,
                child: Image.asset(image),
              ),
              const GapWidget(),
              Text(title,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
