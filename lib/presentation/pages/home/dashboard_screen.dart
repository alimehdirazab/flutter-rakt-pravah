import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rakt_pravah/core/ui.dart';
import 'package:rakt_pravah/logic/cubit/main_cubit.dart';
import 'package:rakt_pravah/logic/cubit/main_states.dart';
import 'package:rakt_pravah/data/models/banner_response.dart';

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryColor,
        title: const Text('Welcome Anuj'),
      ),
      body: BlocBuilder<MainCubit, MainState>(
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
    );
  }

  Widget _buildBannerUI(BannerData banner) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20.0),
          Image.network(
            banner.image,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width * 0.8,
            height: 200.0,
          ),
          const SizedBox(height: 20.0),
          Text(
            banner.title,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
