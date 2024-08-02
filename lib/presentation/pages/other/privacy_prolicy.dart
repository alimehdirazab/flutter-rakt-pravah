import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:rakt_pravah/logic/cubit/main_cubit.dart';
import 'package:rakt_pravah/logic/cubit/main_states.dart';
import 'package:rakt_pravah/core/ui.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});
  static const String routeName = "privacyPolicy";

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<MainCubit>(context).fetchPrivacyPolicy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: BlocBuilder<MainCubit, MainState>(
        builder: (context, state) {
          if (state is PrivacyPolicyLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PrivacyPolicySuccessState) {
            return ListView.builder(
              itemCount: state.response.data.length,
              itemBuilder: (context, index) {
                final policyData = state.response.data[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        policyData.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Use the Html widget to render HTML content
                      Html(
                        data: policyData.description,
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is PrivacyPolicyFailureState) {
            return Center(
              child: Text(
                'Error: ${state.error}',
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
