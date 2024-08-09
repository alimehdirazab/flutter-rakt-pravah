import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rakt_pravah/core/api.dart';
import 'package:rakt_pravah/core/ui.dart';
import 'package:rakt_pravah/data/repositories/main_repository.dart';
import 'package:rakt_pravah/logic/cubit/main_states.dart';
import 'package:rakt_pravah/logic/cubit/main_cubit.dart';
import 'package:rakt_pravah/logic/services/shared_preferences.dart';
import 'package:rakt_pravah/presentation/pages/auth/otp_screen.dart';
import 'package:rakt_pravah/presentation/widgets/custom_dialog_box.dart';
import 'package:rakt_pravah/presentation/widgets/gap_widget.dart';
import 'package:rakt_pravah/presentation/widgets/primary_button.dart';
import 'package:dio/dio.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  static const String routeName = "signInScreen";

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController mobileController = TextEditingController();

  @override
  void dispose() {
    mobileController.dispose();
    super.dispose();
  }

  void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogBox(
            title: 'OTP Success',
            description: 'OTP sent successfully!',
            onOkPressed: () {
              Navigator.pushReplacementNamed(context, OtpScreen.routeName,
                  arguments: mobileController.text.trim());
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainCubit(MainRepository(Api())),
      child: SafeArea(
        child: Scaffold(
          // Use a Stack to position elements over the background
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              // Bottom background image
              Positioned(
                bottom: -10,
                left: 0,
                right: 0,
                child: Image.asset(
                  'assets/images/background_bottom.png',
                  fit: BoxFit.cover,
                ),
              ),
              // Main content
              Align(
                alignment: Alignment.topCenter,
                child: BlocConsumer<MainCubit, MainState>(
                  listener: (context, state) {
                    if (state is OtpSuccessState) {
                      // Show success message and navigate to OTP screen
                      _showCustomDialog(context);
                    } else if (state is OtpFailureState) {
                      // Show error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.error),
                          backgroundColor: Colors.red, // Set color for error
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const GapWidget(
                                size: 75), // Space for the top image
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Image.asset(
                                  'assets/images/rakt_pravah_logo.png'),
                            ),
                            Text('Noble To Save Life', style: TextStyles.body2),
                            const GapWidget(),
                            Text(
                              'Hello Welcome To Rakt Pravah !!',
                              style: TextStyles.heading4
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                            const GapWidget(),
                            Text(
                              '3 easy steps to join our Smartsaver Community\n       to Find a Donor or Become a Donor ',
                              style: TextStyles.body4,
                            ),
                            const GapWidget(size: 30),
                            TextFormField(
                              controller: mobileController,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                hintText: ' Mobile Number*',
                                prefix: Text(
                                  '+91  ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                                suffixIcon: Icon(
                                  Icons.phone_android,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            const GapWidget(size: 20),
                            if (state
                                is OtpLoadingState) // Show loading indicator when loading
                              const CircularProgressIndicator(),
                            PrimaryButton(
                              onPressed: () {
                                final mobile = mobileController.text;
                                if (mobile.isNotEmpty && mobile.length == 10) {
                                  // Validate mobile number
                                  SharedPreferencesHelper.savePhoneNumber(
                                      mobile);
                                  context.read<MainCubit>().requestOtp(mobile);
                                } else {
                                  // Show validation error
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Please enter a valid mobile number'),
                                      backgroundColor: Colors
                                          .red, // Set color for validation error
                                    ),
                                  );
                                }
                              },
                              text: 'Get OTP',
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
