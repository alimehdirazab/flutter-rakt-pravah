import 'package:flutter/material.dart';
import 'package:rakt_pravah/core/ui.dart';

class SmartSaverCard extends StatelessWidget {
  final String userId;
  final String bloodGroup;
  const SmartSaverCard(
      {super.key, required this.userId, required this.bloodGroup});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 40, bottom: 20),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Smartsaver-$userId',
                      style: TextStyles.heading4,
                    ),
                    const Text(
                      'USER ID',
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
                const Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      'Blood Group',
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: Image.asset('assets/icons/icon-4.png'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Text(
                bloodGroup,
                style: const TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ],
    );
  }
}
