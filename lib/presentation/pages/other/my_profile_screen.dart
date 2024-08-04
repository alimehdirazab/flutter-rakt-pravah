import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rakt_pravah/core/ui.dart';
import 'package:rakt_pravah/logic/cubit/profile%20cubit/profile_cubit.dart';
import 'package:rakt_pravah/logic/cubit/profile%20cubit/profile_states.dart';
import 'package:rakt_pravah/presentation/widgets/gap_widget.dart';
import 'package:rakt_pravah/presentation/widgets/profile_detail_tile.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});
  static const String routeName = "myProfileScreen";

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getProfileDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text('My Profile'),
        centerTitle: true,
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileError) {
            return Center(child: Text(state.errorMessage));
          } else if (state is ProfileSuccess) {
            final profile = state.profileResponse.data;
            return SingleChildScrollView(
              child: Column(
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
                  Text(
                    profile.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const GapWidget(),
                  Text(
                    profile.mobile,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const GapWidget(size: -10),
                  Text(
                    profile.location,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const GapWidget(size: -10),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(
                        profile.bloodGroup,
                        style: const TextStyle(color: Colors.white),
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
                              value: profile.isHivPositive == 'yes',
                              onChanged: (value) {
                                // Handle switch state change
                              },
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Last Blood Donation Date '),
                                const GapWidget(),
                                Container(
                                  width: 140,
                                  height: 40,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(profile.lastDate),
                                      const VerticalDivider(),
                                      const Icon(Icons.date_range)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ProfileDetailTile(
                              title: 'Date of Birth',
                              subtitle: profile.dob
                                  .toLocal()
                                  .toString()
                                  .split(' ')[0],
                            ),
                            const ProfileDetailTile(
                              title: 'Gender',
                              subtitle: 'Not Specified',
                            ),
                            IconButton.outlined(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.yellow,
                              ),
                            ),
                          ],
                        ),
                        const GapWidget(size: -10),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ProfileDetailTile(
                              title: 'Weight in Kgs',
                              subtitle: 'Not Specified',
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Did you get tattoo in past 12 months?',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            IconButton.outlined(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.yellow,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              profile.tattoo == 'yes' ? 'Yes' : 'No',
                              style: const TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                        const GapWidget(),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Have you ever tested positive for HIV?',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const GapWidget(size: -10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              profile.isHivPositive == 'yes' ? 'Yes' : 'No',
                              style: const TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }
          return Container(); // Return empty container if no state is matched
        },
      ),
    );
  }
}
