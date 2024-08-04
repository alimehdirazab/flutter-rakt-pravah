// dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:rakt_pravah/core/ui.dart';
import 'package:rakt_pravah/data/models/banner_response.dart';
import 'package:rakt_pravah/logic/cubit/banner%20cubit/banner_cubit.dart';
import 'package:rakt_pravah/logic/cubit/banner%20cubit/banner_state.dart';
import 'package:rakt_pravah/logic/cubit/main_cubit.dart';
import 'package:rakt_pravah/logic/cubit/main_states.dart';
import 'package:rakt_pravah/logic/cubit/profile%20cubit/profile_cubit.dart';
import 'package:rakt_pravah/logic/cubit/profile%20cubit/profile_states.dart';
import 'package:rakt_pravah/presentation/widgets/dashboard_card.dart';
import 'package:rakt_pravah/presentation/widgets/gap_widget.dart';
import 'package:rakt_pravah/presentation/widgets/requests_card.dart';
import 'package:rakt_pravah/presentation/widgets/smart_saver_card.dart';
import 'package:rakt_pravah/data/models/profile_response.dart';
import 'package:rakt_pravah/data/models/blood_request_list_response.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late MainCubit _mainCubit;
  late BannerCubit _bannerCubit;
  late ProfileCubit _profile;
  ProfileResponse? _profileResponse;
  BloodRequestListResponse? _bloodRequestListResponse;

  @override
  void initState() {
    super.initState();
    _mainCubit = BlocProvider.of<MainCubit>(context);
    _bannerCubit = BlocProvider.of<BannerCubit>(context);
    _profile = BlocProvider.of<ProfileCubit>(context);
    //////////////////////////
    _profile.getProfileDetails();
    _bannerCubit.fetchBanner();
    _mainCubit.getBloodRequestList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          icon: const Icon(Icons.list, size: 30),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            const Icon(
              Icons.account_circle_rounded,
              color: Colors.white,
              size: 28,
            ),
            BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                if (state is ProfileSuccess) {
                  _profileResponse = state.profileResponse;
                  print('Profile data: ${_profileResponse?.data}');
                  return Text(
                    '   Welcome ${_profileResponse?.data.name ?? 'User'}',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  );
                } else if (state is ProfileError) {
                  return Text(
                    'Error: ${state.errorMessage}',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  );
                }
                return const Text(
                  '   Loading...',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                );
              },
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(CupertinoIcons.bell),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 60),
                  child: Container(
                    width: double.infinity,
                    height: 80,
                    color: AppColors.primaryColor,
                  ),
                ),
                BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    if (state is ProfileSuccess) {
                      _profileResponse = state.profileResponse;
                      return SmartSaverCard(
                        userId: _profileResponse?.data.id.toString() ?? 'N/A',
                        bloodGroup: _profileResponse?.data.bloodGroup ?? 'N/A',
                      );
                    } else if (state is ProfileError) {
                      return const SmartSaverCard(
                        userId: 'Error',
                        bloodGroup: 'Error',
                      );
                    }
                    return const SmartSaverCard(
                      userId: 'Loading...',
                      bloodGroup: 'Loading...',
                    );
                  },
                ),
              ],
            ),
            BlocBuilder<BannerCubit, BannerState>(
              builder: (context, state) {
                if (state is BannerLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is BannerSuccessState) {
                  return _buildBannerUI(state.response.data);
                } else if (state is BannerFailureState) {
                  return Center(child: Text('Error: ${state.error}'));
                }
                return Container();
              },
            ),
            const GapWidget(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  DashboardCard(
                      image: 'assets/icons/icon-1.png',
                      title: 'Request for Blood'),
                  GapWidget(),
                  DashboardCard(
                      image: 'assets/icons/icon-2.png', title: 'Donate Blood'),
                ],
              ),
            ),
            const GapWidget(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: BlocBuilder<MainCubit, MainState>(
                builder: (context, state) {
                  if (state is BloodRequestListLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is BloodRequestListSuccess) {
                    _bloodRequestListResponse = state.bloodRequestListResponse;
                    return _buildBloodRequestListUI(
                        _bloodRequestListResponse?.data ?? []);
                  } else if (state is BloodRequestListError) {
                    return Center(child: Text('Error: ${state.errorMessage}'));
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerUI(BannerData banner) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          banner.image,
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width * 0.9,
          height: 130,
        ),
      ),
    );
  }

  Widget _buildBloodRequestListUI(List<BloodRequestList> requests) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: requests.map((request) {
          return RequestsCard(
            bloodGroup: request.bloodGroup!,
            name: '${request.patientFirstName} ${request.patientLastName}',
            units: '${request.numberOfUnits} Units (${request.requestType})',
            address: request.locationForDonation ?? "N/A",
            date: request.requiredDate!,
          );
        }).toList(),
      ),
    );
  }
}
