import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:rakt_pravah/logic/cubit/main_cubit.dart';
import 'package:rakt_pravah/logic/cubit/main_states.dart';
import 'package:rakt_pravah/presentation/pages/auth/registor_details.dart';
import 'package:rakt_pravah/presentation/pages/home/home_page.dart';
import 'package:rakt_pravah/presentation/widgets/custom_dialog_box.dart';
import 'package:rakt_pravah/presentation/widgets/gap_widget.dart';
import 'package:rakt_pravah/presentation/widgets/otp_box.dart';
import 'package:rakt_pravah/presentation/widgets/primary_button.dart';
import 'package:rakt_pravah/core/ui.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  const OtpScreen({super.key, required this.phoneNumber});

  static const String routeName = "otpScreen";

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> with CodeAutoFill {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes; // List of FocusNodes
  bool _isResendEnabled = false;
  bool _showResendButton = false;
  int _resendTimerSeconds = 45;
  late Timer _resendTimer;

  String? appSignature;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(6, (index) => TextEditingController());
    _focusNodes =
        List.generate(6, (index) => FocusNode()); // Initialize FocusNodes
    startResendTimer();
    _listenForSmsCode();
    _getAppSignature();
  }

  @override
  void dispose() {
    _controllers.forEach((controller) => controller.dispose());
    _focusNodes
        .forEach((focusNode) => focusNode.dispose()); // Dispose FocusNodes
    _resendTimer.cancel();
    cancel();
    super.dispose();
  }

  // Method to fetch app signature
  void _getAppSignature() async {
    appSignature = await SmsAutoFill().getAppSignature;
    print("App Signature: $appSignature");
  }

  // Method to start listening for SMS code
  void _listenForSmsCode() {
    listenForCode();
  }

  @override
  void codeUpdated() {
    // Retrieve the code from the autofill service and update the text fields
    SmsAutoFill().code.listen((code) {
      for (int i = 0; i < code.length; i++) {
        _controllers[i].text = code[i];
      }
    });
  }

  void startResendTimer() {
    setState(() {
      _isResendEnabled = false;
      _showResendButton = false;
    });

    _resendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _resendTimerSeconds--;
        if (_resendTimerSeconds == 0) {
          _showResendButton = true;
          _resendTimer.cancel();
        }
      });
    });
  }

  void _handleResend() {
    // Call the OTP request function
    context.read<MainCubit>().requestOtp(widget.phoneNumber);

    // Restart the timer
    setState(() {
      _resendTimerSeconds = 45;
      _showResendButton = false;
      startResendTimer();
    });
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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const GapWidget(size: 120), // Space for the top image
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Image.asset('assets/images/rakt_pravah_logo.png'),
                ),
                Text('Noble To Save Life', style: TextStyles.body2),
                const GapWidget(),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'OTP has been sent to\n',
                        style: TextStyles.heading4.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: widget.phoneNumber,
                        style: TextStyles.heading4.copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: ' via SMS\n',
                        style: TextStyles.heading4.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const GapWidget(),
                Form(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      6,
                      (index) => Expanded(
                        child: OtpBox(
                          controller: _controllers[index],
                          focusNode: _focusNodes[
                              index], // Assign the corresponding FocusNode
                          textInputAction: index < 5
                              ? TextInputAction.next
                              : TextInputAction.done, // Set text input action
                          onChanged: (value) {
                            if (value.isNotEmpty && index < 5) {
                              FocusScope.of(context)
                                  .requestFocus(_focusNodes[index + 1]);
                            } else if (value.isEmpty && index > 0) {
                              FocusScope.of(context)
                                  .requestFocus(_focusNodes[index - 1]);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const GapWidget(),
                BlocConsumer<MainCubit, MainState>(
                  listener: (context, state) {
                    if (state is VerifyOtpSuccessState) {
                      // Check registration status and navigate accordingly
                      if (state.response.data?.registrationStatus == 1) {
                        _showCustomDialog(
                          context,
                          'LoggedIn',
                          'You are Successfully LoggedIn',
                          () {
                            Navigator.pushReplacementNamed(
                                context, HomePage.routeName);
                          },
                        );
                      } else {
                        _showCustomDialog(
                          context,
                          'Account Created',
                          'Your Account is Successfully Created\nPlease Register Your Details!',
                          () {
                            Navigator.pushNamed(
                                context, RegistorDetails.routeName,
                                arguments: widget.phoneNumber);
                          },
                        );
                      }
                    } else if (state is VerifyOtpFailureState) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(state.error),
                      ));
                    }
                  },
                  builder: (context, state) {
                    return PrimaryButton(
                      text: 'Verify',
                      onPressed: () {
                        String otp = _controllers
                            .map((controller) => controller.text)
                            .join();
                        if (otp.length != 6) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor:
                                  Color.fromARGB(255, 151, 130, 128),
                              content: Text('Please enter a valid OTP.'),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        } else {
                          context
                              .read<MainCubit>()
                              .verifyOtp(widget.phoneNumber, otp);
                        }
                      },
                    );
                  },
                ),
                const GapWidget(),
                Text(
                  '00:$_resendTimerSeconds',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 20,
                  ),
                ),
                if (_showResendButton)
                  TextButton(
                    onPressed: _handleResend,
                    child: Text(
                      'Resend OTP',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                const GapWidget(size: 70), // Space for the bottom image
              ],
            ),
          ),
        ),
      ),
    );
  }
}
