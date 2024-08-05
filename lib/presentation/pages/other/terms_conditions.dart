import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:rakt_pravah/logic/cubit/main_cubit.dart';
import 'package:rakt_pravah/logic/cubit/main_states.dart';
import 'package:rakt_pravah/core/ui.dart';
import 'package:rakt_pravah/presentation/pages/home/home_page.dart';

class TermsConditions extends StatefulWidget {
  const TermsConditions({super.key});
  static const String routeName = "termsConditions";

  @override
  State<TermsConditions> createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<MainCubit>(context).fetchTermsAndConditions();
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
        appBar: AppBar(
          title: const Text('Terms and Conditions'),
          backgroundColor: AppColors.primaryColor,
        ),
        body: BlocBuilder<MainCubit, MainState>(
          builder: (context, state) {
            if (state is TermsLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TermsSuccessState) {
              return ListView.builder(
                itemCount: state.response.data.length,
                itemBuilder: (context, index) {
                  final termsData = state.response.data[index];
                  return Column(
                    children: [
                      Image.asset('assets/images/About_banner.png'),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              termsData.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Use the Html widget to render HTML content
                            Html(
                              data: termsData.description,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            } else if (state is TermsFailureState) {
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
      ),
    );
  }
}
