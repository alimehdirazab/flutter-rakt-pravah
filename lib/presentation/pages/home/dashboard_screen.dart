import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rakt_pravah/core/api.dart';
import 'package:rakt_pravah/core/ui.dart';
import 'package:rakt_pravah/data/models/banner_response.dart';
import 'package:rakt_pravah/data/models/blood_request_list_response.dart';
import 'package:rakt_pravah/data/models/profile_response.dart';
import 'package:rakt_pravah/data/repositories/main_repository.dart';
import 'package:rakt_pravah/logic/cubit/banner%20cubit/banner_cubit.dart';
import 'package:rakt_pravah/logic/cubit/banner%20cubit/banner_state.dart';
import 'package:rakt_pravah/logic/cubit/main_cubit.dart';
import 'package:rakt_pravah/logic/cubit/main_states.dart';
import 'package:rakt_pravah/logic/cubit/profile%20cubit/profile_cubit.dart';
import 'package:rakt_pravah/logic/cubit/profile%20cubit/profile_states.dart';
import 'package:rakt_pravah/logic/services/shared_preferences.dart';
import 'package:rakt_pravah/presentation/pages/home/home_page.dart';
import 'package:rakt_pravah/presentation/pages/home/request_for_blood_screen.dart';
import 'package:rakt_pravah/presentation/pages/other/my_profile_screen.dart';
import 'package:rakt_pravah/presentation/pages/other/request_screen.dart';
import 'package:rakt_pravah/presentation/widgets/custom_dialog_box.dart';
import 'package:rakt_pravah/presentation/widgets/dashboard_card.dart';
import 'package:rakt_pravah/presentation/widgets/gap_widget.dart';
import 'package:rakt_pravah/presentation/widgets/requests_card.dart';
import 'package:rakt_pravah/presentation/widgets/smart_saver_card.dart';
import 'package:shimmer/shimmer.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  static const String routeName = 'DashboardPage';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final MainRepository _mainRepository =
      MainRepository(Api()); // Create an instance of the repository
  late MainCubit _mainCubit;
  late BannerCubit _bannerCubit;
  late ProfileCubit _profileCubit;

  ProfileResponse? _profileResponse;
  BloodRequestListResponse? _bloodRequestListResponse;

  String? myBloodGroup;

  int _currentBannerIndex =
      0; // To track the current banner index for pagination indicators
  // Initialize CarouselControllerPlus
  CarouselController _carouselController = CarouselController();

  @override
  void initState() {
    super.initState();
    _mainCubit = BlocProvider.of<MainCubit>(context);
    _bannerCubit = BlocProvider.of<BannerCubit>(context);
    _profileCubit = BlocProvider.of<ProfileCubit>(context);

    // Fetch data on initialization
    _mainCubit.getBloodRequestList();
    _profileCubit.getProfileDetails();
    _bannerCubit.fetchBanner();
  }

  void _showCustomDialog(BuildContext context, String title, String description,
      void Function() onOkPressed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogBox(
          title: title,
          description: description,
          onOkPressed: onOkPressed,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return _showExitConfirmationDialog(context);
      },
      child: RefreshIndicator(
        onRefresh: () {
          _mainCubit.getBloodRequestList();
          _profileCubit.getProfileDetails();
          _bannerCubit.fetchBanner();

          return Future.value(true);
        },
        child: Scaffold(
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
            title: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, MyProfileScreen.routeName);
              },
              child: Row(
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
                        SharedPreferencesHelper.saveName(
                            _profileResponse?.data?.name ?? "");
                        return Text(
                          '   Welcome ${_profileResponse?.data?.name ?? 'User'}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        );
                      } else if (state is ProfileError) {
                        return Text(
                          'Error: ${state.errorMessage}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
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
            ),
            // actions: [
            //   IconButton(
            //     onPressed: () {},
            //     icon: const Icon(CupertinoIcons.bell),
            //   ),
            // ],
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
                          myBloodGroup =
                              _profileResponse?.data?.bloodGroup ?? 'N/A';
                          return SmartSaverCard(
                            userId:
                                _profileResponse?.data?.uniqueId.toString() ??
                                    'N/A',
                            bloodGroup:
                                _profileResponse?.data?.bloodGroup ?? 'N/A',
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
                      // Show shimmer while loading banner
                      return _buildShimmerBanner();
                    } else if (state is BannerSuccessState) {
                      return _buildBannerUI(state.response.data);
                    } else if (state is BannerFailureState) {
                      return Center(child: Text('Error: ${state.error}'));
                    }
                    return Container();
                  },
                ),
                const GapWidget(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      DashboardCard(
                        image: 'assets/icons/icon-1.png',
                        title: 'Request for Blood',
                        onTap: () {
                          // Navigate to request blood page
                          Navigator.pushNamed(
                              context, RequestForBloodScreen.routeName);
                        },
                      ),
                      const GapWidget(),
                      DashboardCard(
                        image: 'assets/icons/icon-2.png',
                        title: 'Donate Blood',
                        onTap: () {
                          // Navigate to donate blood page
                          Navigator.pushNamed(context, RequestScreen.routeName);
                        },
                      ),
                    ],
                  ),
                ),
                const GapWidget(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: BlocBuilder<MainCubit, MainState>(
                    builder: (context, state) {
                      if (state is BloodRequestListLoading) {
                        // Show shimmer while loading blood requests
                        return _buildShimmerBloodRequestList();
                      } else if (state is BloodRequestListSuccess) {
                        _bloodRequestListResponse =
                            state.bloodRequestListResponse;
                        return _buildBloodRequestListUI(
                            _bloodRequestListResponse?.data ?? []);
                      } else if (state is BloodRequestListError) {
                        return Center(
                            child: Text('Error: ${state.errorMessage}'));
                      }
                      return Container();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Build the banner UI as a slider using CarouselSliderPlus
  Widget _buildBannerUI(List<BannerData> banners) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 155,
            viewportFraction: 0.9,
            autoPlay: true, // Enable automatic sliding
            autoPlayInterval:
                const Duration(seconds: 5), // Duration between slides
            enlargeCenterPage: true, // Enlarge the center image for focus
            onPageChanged: (index, reason) {
              setState(() {
                _currentBannerIndex = index; // Update the current index
              });
            },
          ),
          items: banners.map((banner) {
            return Builder(
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(banner.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
          // controller: _carouselController,
        ),
        const GapWidget(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: banners.asMap().entries.map((entry) {
            return GestureDetector(
              child: Container(
                width: _currentBannerIndex == entry.key
                    ? 12
                    : 8, // Indicate active banner with a larger indicator
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentBannerIndex == entry.key
                      ? AppColors.primaryColor
                      : Colors.grey,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Build shimmer effect for the banner while loading
  Widget _buildShimmerBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SizedBox(
        height: 155,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (context, index) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 155,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Build the blood request list UI
  Widget _buildBloodRequestListUI(List<BloodRequestList> requests) {
    // Filter the requests based on the user's blood group
    List<BloodRequestList> filteredRequests = requests.where((request) {
      return myBloodGroup == request.bloodGroup;
    }).toList();

    if (filteredRequests.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            'No blood requests available for your blood group.',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ),
      );
    }

    // If there is only one request, show it without the carousel slider
    if (filteredRequests.length == 1) {
      return RequestsCard(
        bloodGroup: filteredRequests[0].bloodGroup ?? "NA",
        name:
            '${filteredRequests[0].patientFirstName} ${filteredRequests[0].patientLastName}',
        units:
            '${filteredRequests[0].numberOfUnits} Units (${filteredRequests[0].requestType})',
        address: filteredRequests[0].locationForDonation ?? "N/A",
        date: filteredRequests[0].requiredDate ?? "N/A",
        onAcceptPressed: () async {
          // Handle accept button press
          try {
            String? message = await _mainRepository.acceptBloodRequest(
                requestId: filteredRequests[0].id);

            if (message != null) {
              _showCustomDialog(
                  context,
                  'Blood Request Accepted',
                  'Blood Request Accepted Successfully',
                  () =>
                      Navigator.pushNamed(context, DashboardScreen.routeName));
            }
          } catch (e) {
            _showCustomDialog(
                context,
                'Failed Accepting Blood Request',
                'Failed: To Accept Blood Request',
                () => Navigator.pushNamed(context, HomePage.routeName));
          }
        },
      );
    }

    // Use CarouselSlider if there is more than one request
    return CarouselSlider(
      options: CarouselOptions(
        height: 220.0, // Set an appropriate height for the cards
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5), // 5 seconds delay
        viewportFraction: 1.1,
        enlargeCenterPage: true,
      ),
      items: filteredRequests.map((request) {
        return Builder(
          builder: (BuildContext context) {
            return RequestsCard(
              bloodGroup: request.bloodGroup ?? "NA",
              name: '${request.patientFirstName} ${request.patientLastName}',
              units: '${request.numberOfUnits} Units (${request.requestType})',
              address: request.locationForDonation ?? "N/A",
              date: request.requiredDate ?? "N/A",
              onAcceptPressed: () async {
                // Handle accept button press
                try {
                  String? message = await _mainRepository.acceptBloodRequest(
                      requestId: request.id);

                  if (message != null) {
                    _showCustomDialog(
                        context,
                        'Blood Request Accepted',
                        'Blood Request Accepted Successfully',
                        () => Navigator.pushNamed(
                            context, DashboardScreen.routeName));
                  }
                } catch (e) {
                  _showCustomDialog(
                      context,
                      'Failed Accepting Blood Request',
                      'Failed: To Accept Blood Request',
                      () => Navigator.pushNamed(context, HomePage.routeName));
                }
              },
            );
          },
        );
      }).toList(),
    );
  }

  // Build shimmer effect for blood request list while loading
  Widget _buildShimmerBloodRequestList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        );
      },
    );
  }

  // Show confirmation dialog when trying to exit the app
  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Exit Confirmation'),
              content: const Text('Are you sure you want to exit the app?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: const Text('Exit'),
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
