import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:rakt_pravah/core/api.dart';
import 'package:rakt_pravah/core/ui.dart';
import 'package:rakt_pravah/data/repositories/main_repository.dart';
import 'package:rakt_pravah/logic/cubit/profile%20cubit/profile_cubit.dart';
import 'package:rakt_pravah/logic/cubit/profile%20cubit/profile_states.dart';
import 'package:rakt_pravah/presentation/pages/home/home_page.dart';
import 'package:rakt_pravah/presentation/pages/other/edit_profile.dart';
import 'package:rakt_pravah/presentation/widgets/gap_widget.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});
  static const String routeName = "myProfileScreen";

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  final MainRepository _mainRepository =
      MainRepository(Api()); // Create an instance of the repository

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getProfileDetails();
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        File imageFile = File(image.path);
        // Call the repository function to upload the image
        String? message =
            await _mainRepository.uploadProfileImage(profileImage: imageFile);
        if (message != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
          // Refresh profile data after upload
          context.read<ProfileCubit>().getProfileDetails();
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to upload image: $e')));
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "N/A";
    try {
      final DateFormat outputFormat = DateFormat('yyyy-MM-dd');
      return outputFormat.format(date);
    } catch (e) {
      return "N/A";
    }
  }

  String _formatDateFromDate(DateTime? date) {
    return _formatDate(date);
  }

  DateTime? _parseDateString(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      final DateFormat inputFormat =
          DateFormat('d/M/yyyy'); // Adjust format as needed
      return inputFormat.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushNamedAndRemoveUntil(
          HomePage.routeName,
          (route) => false,
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: const Text('My Profile'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: BlocBuilder<ProfileCubit, ProfileState>(
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
                                padding:
                                    const EdgeInsets.only(right: 0, bottom: 20),
                                child: ClipOval(
                                  child: //profile!.image != null ||
                                      profile!.image !=
                                              "https://raktpravah.com/uploads/images/profile/"
                                          ? Image.network(
                                              profile.image ?? "N/A",
                                              width: 90,
                                              height: 90,
                                              fit: BoxFit.cover,
                                            )
                                          : const Icon(
                                              Icons.person,
                                              size: 90,
                                            ),
                                ),
                              ),
                              CircleAvatar(
                                child: IconButton(
                                  onPressed: _pickAndUploadImage,
                                  icon: const Icon(
                                    Icons.camera_alt,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        profile?.name ?? "N/A",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const GapWidget(),
                      Text(
                        profile?.mobile ?? "N/A",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const GapWidget(size: -10),
                      Text(
                        profile?.location ?? "N/A",
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
                            profile?.bloodGroup ?? "N/A",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton.outlined(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EditProfile(
                                    profileData: state.profileResponse.data,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.yellow,
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
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
                                  value: profile?.isHivPositive == 1,
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
                                          Text(
                                            profile.lastDate ?? "N/A",
                                          ),
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
                                Column(
                                  children: [
                                    const Text(
                                      'Date of Birth',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    const GapWidget(size: -10),
                                    Text(profile.dob ?? 'N/A'),
                                  ],
                                )
                              ],
                            ),
                            const GapWidget(size: -10),
                            const Divider(),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Did you get tattoo in past 12 months?',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  profile?.tattoo == 1 ? 'Yes' : 'No',
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
                                  profile?.isHivPositive == 1 ? 'Yes' : 'No',
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
        ),
      ),
    );
  }
}
