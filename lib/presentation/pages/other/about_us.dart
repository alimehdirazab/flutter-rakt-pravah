import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:rakt_pravah/core/ui.dart';
import 'package:rakt_pravah/logic/cubit/main_cubit.dart';
import 'package:rakt_pravah/logic/cubit/main_states.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});
  static const String routeName = "aboutUs";

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<MainCubit>(context).fetchAboutUs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: BlocBuilder<MainCubit, MainState>(
        builder: (context, state) {
          if (state is AboutUsLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AboutUsSuccessState) {
            final aboutUsData = state.response.data;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (aboutUsData.image.isNotEmpty)
                    Image.network(aboutUsData.image),
                  const SizedBox(height: 16),
                  Text(
                    aboutUsData.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Use the Html widget to render HTML content
                  Html(
                    data: aboutUsData.description,
                  ),
                ],
              ),
            );
          } else if (state is AboutUsFailureState) {
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
