import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rakt_pravah/core/ui.dart';
import 'package:rakt_pravah/presentation/widgets/gap_widget.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});
  static const String routeName = "myProfileScreen";

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  bool _isCritical = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text('My Profile'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Container(
                  width: double.infinity,
                  height: 60,
                  color: AppColors.primaryColor,
                ),
              ),
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.grey[300],
                      child: const Icon(
                        Icons.person_2_outlined,
                        color: Colors.red,
                        size: 50,
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey[100],
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ],
              )
            ],
          ),
          const GapWidget(),
          const Text(
            'Anuj Rana',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const GapWidget(),
          const Text(
            '7678367852',
            style: TextStyle(color: Colors.grey),
          ),
          const GapWidget(size: -10),
          const Text(
            'Secor 15, Noida,Uttar Pradesh, India',
            style: TextStyle(color: Colors.grey),
          ),
          const GapWidget(size: -10),
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(17),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'A+',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Are you Available'),
                    Switch(
                      value: _isCritical,
                      onChanged: (value) {
                        setState(() {
                          _isCritical = value;
                        });
                      },
                    ),
                  ],
                ),
                const Divider(),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Last Blood Donation Date '),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // const ListTile(
                    //   title: Text(
                    //     'Date of Birth',
                    //     style: TextStyle(color: Colors.grey),
                    //   ),
                    //   subtitle: Text('12-12-1998'),
                    // ),
                    // const ListTile(
                    //   title: Text(
                    //     'Gender',
                    //     style: TextStyle(color: Colors.grey),
                    //   ),
                    //   subtitle: Text('Not Specified'),
                    // ),
                    IconButton.outlined(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.yellow,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
