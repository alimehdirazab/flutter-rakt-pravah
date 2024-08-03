import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rakt_pravah/core/ui.dart';
import 'package:rakt_pravah/logic/cubit/main_cubit.dart';
import 'package:rakt_pravah/logic/cubit/main_states.dart';
import 'package:rakt_pravah/data/models/banner_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:rakt_pravah/presentation/widgets/dashboard_card.dart';
import 'package:rakt_pravah/presentation/widgets/gap_widget.dart';
import 'package:rakt_pravah/presentation/widgets/requests_card.dart';
import 'package:rakt_pravah/presentation/widgets/smart_saver_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late MainCubit _mainCubit;

  @override
  void initState() {
    super.initState();
    _mainCubit = BlocProvider.of<MainCubit>(context);
    _mainCubit.fetchBanner();
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
            // Use Scaffold.of(context) to open the Drawer
            // Ensure the widget is wrapped in a Builder
            Scaffold.of(context).openDrawer();
          },
          icon: const Icon(Icons.list, size: 30),
        ),
        titleSpacing: 0,
        title: const Row(
          children: [
            Icon(
              Icons.account_circle_rounded,
              color: Colors.white,
              size: 28,
            ),
            Text(
              '   Welcome Anuj',
              style: TextStyle(color: Colors.white, fontSize: 14),
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
                const SmartSaverCard(
                  userId: '123444',
                  bloodGroup: 'B+',
                ),
              ],
            ),
            BlocBuilder<MainCubit, MainState>(
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    RequestsCard(
                      bloodGroup: 'B+',
                      name: 'Ali Mehdi Raza',
                      units: '1 Units (Platelets)',
                      address: 'Sultan Abad Karachi',
                      date: 'Friday, Aug 20',
                    ),
                    GapWidget(),
                    RequestsCard(
                      bloodGroup: 'B+',
                      name: 'Ali Mehdi Raza',
                      units: '1 Units (Platelets)',
                      address: 'Sultan Abad Karachi',
                      date: 'Friday, Aug 20',
                    ),
                  ],
                ),
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
}
