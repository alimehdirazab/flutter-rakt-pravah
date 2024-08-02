import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rakt_pravah/core/ui.dart';
import 'package:rakt_pravah/logic/cubit/main_cubit.dart';
import 'package:rakt_pravah/logic/cubit/main_states.dart';
import 'package:rakt_pravah/presentation/pages/home/home_page.dart';
import 'package:rakt_pravah/presentation/pages/other/privacy_prolicy.dart';
import 'package:rakt_pravah/presentation/pages/other/terms_conditions.dart';
import 'package:rakt_pravah/presentation/widgets/custom_dialog_box.dart';
import 'package:rakt_pravah/presentation/widgets/gap_widget.dart';
import 'package:rakt_pravah/presentation/widgets/link_button.dart';
import 'package:rakt_pravah/presentation/widgets/primary_button.dart';
import 'package:rakt_pravah/presentation/widgets/primary_textfield.dart';

class RegistorDetails extends StatefulWidget {
  final String phoneNumber;
  const RegistorDetails({super.key, required this.phoneNumber});
  static const String routeName = "RegistorDetails";

  @override
  State<RegistorDetails> createState() => _RegistorDetailsState();
}

class _RegistorDetailsState extends State<RegistorDetails> {
  // Define controllers for form fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _tattoo = false; // Checkbox state for tattoo
  bool _isHivPositive = false; // Checkbox state for HIV

  String? _selectedBloodGroup; // Store selected blood group

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Set the initial value of _mobileController to the phoneNumber passed to the widget
    _mobileController.text = widget.phoneNumber;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _locationController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
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
      appBar: AppBar(
        title: const Text('Register Details'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: BlocConsumer<MainCubit, MainState>(
        listener: (context, state) {
          if (state is RegisterSuccessState) {
            _showCustomDialog(
              context,
              'Registration  Successfully',
              'You Are now loggedIn in Your Account',
              () {
                Navigator.pushReplacementNamed(context, HomePage.routeName);
              },
            );
          } else if (state is RegisterFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text('Great Going!', style: TextStyles.heading4),
                    const GapWidget(size: -6),
                    Text(
                      'Please Provide further details to register as a ',
                      style: TextStyles.body3,
                    ),
                    Text('Donor', style: TextStyles.body3),
                    const GapWidget(size: 10),
                    PrimaryTextField(
                      hintText: 'First Name',
                      icon: Icons.person,
                      controller: _firstNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your first name';
                        }
                        return null;
                      },
                    ),
                    const GapWidget(),
                    PrimaryTextField(
                      hintText: 'Last Name',
                      icon: Icons.person,
                      controller: _lastNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your last name';
                        }
                        return null;
                      },
                    ),
                    const GapWidget(),
                    PrimaryTextField(
                      hintText: 'Mobile Number',
                      icon: Icons.phone,
                      controller: _mobileController,
                      keyboardType: TextInputType.phone,
                      enabled: false, // The field is disabled
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your mobile number';
                        }
                        if (value.length != 10) {
                          return 'Please enter a valid 10-digit mobile number';
                        }
                        return null;
                      },
                    ),
                    const GapWidget(),
                    PrimaryTextField(
                      hintText: 'Email Address',
                      icon: Icons.email,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email address';
                        }
                        if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const GapWidget(),
                    InkWell(
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: AppColors.white,
                                  onPrimary: Colors.white,
                                  surface: AppColors.primaryColor,
                                  onSurface: Colors.white,
                                ),
                                dialogBackgroundColor: Colors.white,
                              ),
                              child: child!,
                            );
                          },
                        );

                        if (pickedDate != null) {
                          setState(() {
                            _dobController.text =
                                '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                          });
                        }
                      },
                      child: PrimaryTextField(
                        hintText: 'Date of Birth',
                        icon: Icons.date_range,
                        controller: _dobController,
                        enabled: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your date of birth';
                          }
                          return null;
                        },
                      ),
                    ),
                    const GapWidget(),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        hintText: 'Select Blood Group',
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 10,
                        ),
                      ),
                      value: _selectedBloodGroup,
                      items: const [
                        DropdownMenuItem(
                          value: 'A+',
                          child: Text('A+'),
                        ),
                        DropdownMenuItem(
                          value: 'A-',
                          child: Text('A-'),
                        ),
                        DropdownMenuItem(
                          value: 'B+',
                          child: Text('B+'),
                        ),
                        DropdownMenuItem(
                          value: 'B-',
                          child: Text('B-'),
                        ),
                        DropdownMenuItem(
                          value: 'AB+',
                          child: Text('AB+'),
                        ),
                        DropdownMenuItem(
                          value: 'AB-',
                          child: Text('AB-'),
                        ),
                        DropdownMenuItem(
                          value: 'O+',
                          child: Text('O+'),
                        ),
                        DropdownMenuItem(
                          value: 'O-',
                          child: Text('O-'),
                        ),
                        DropdownMenuItem(
                          value: 'A1+',
                          child: Text('A1+'),
                        ),
                        DropdownMenuItem(
                          value: 'A1-',
                          child: Text('A1-'),
                        ),
                        DropdownMenuItem(
                          value: 'A2+',
                          child: Text('A2+'),
                        ),
                        DropdownMenuItem(
                          value: 'A2-',
                          child: Text('A2-'),
                        ),
                        DropdownMenuItem(
                          value: 'A1B+',
                          child: Text('A1B+'),
                        ),
                        DropdownMenuItem(
                          value: 'A1B-',
                          child: Text('A1B-'),
                        ),
                        DropdownMenuItem(
                          value: 'A2B+',
                          child: Text('A2B+'),
                        ),
                        DropdownMenuItem(
                          value: 'A2B-',
                          child: Text('A2B='),
                        ),
                        DropdownMenuItem(
                          value: 'Bombay Blood Group',
                          child: Text('Bombay Blood Group'),
                        ),
                        DropdownMenuItem(
                          value: 'INRA',
                          child: Text('INRA'),
                        ),
                        DropdownMenuItem(
                          value: 'Don\'t Known',
                          child: Text('Don\'t Known'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedBloodGroup = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select your blood group';
                        }
                        return null;
                      },
                    ),
                    const GapWidget(),
                    PrimaryTextField(
                      hintText: 'Please Select Location',
                      icon: Icons.pin_drop,
                      controller: _locationController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select your location';
                        }
                        return null;
                      },
                    ),
                    const GapWidget(),
                    Row(
                      children: [
                        Checkbox(
                          value: _tattoo,
                          onChanged: (value) {
                            setState(() {
                              _tattoo = value!;
                            });
                          },
                        ),
                        const Text('Have Tattoo?'),
                      ],
                    ),
                    const GapWidget(),
                    Row(
                      children: [
                        Checkbox(
                          value: _isHivPositive,
                          onChanged: (value) {
                            setState(() {
                              _isHivPositive = value!;
                            });
                          },
                        ),
                        const Text('HIV Positive?'),
                      ],
                    ),
                    const GapWidget(size: 10),
                    const Text('By signing up, you agree to our'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LinkButton(
                          text: 'Terms & Conditions ',
                          onPressed: () {
                            Navigator.pushNamed(
                                context, TermsConditions.routeName);
                          },
                        ),
                        const Text('and '),
                        LinkButton(
                          text: 'Privacy Policy',
                          onPressed: () {
                            Navigator.pushNamed(
                                context, PrivacyPolicy.routeName);
                          },
                        ),
                      ],
                    ),
                    const GapWidget(size: 10),
                    if (state is RegisterLoadingState)
                      const CircularProgressIndicator()
                    else
                      PrimaryButton(
                        text: 'Agree and Signup',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Call Cubit to register user
                            BlocProvider.of<MainCubit>(context).registerUser(
                              firstName: _firstNameController.text.trim(),
                              lastName: _lastNameController.text.trim(),
                              mobile: _mobileController.text.trim(),
                              email: _emailController.text.trim(),
                              bloodGroup: _selectedBloodGroup!,
                              dob: _dobController.text.trim(),
                              tattoo: _tattoo,
                              isHivPositive: _isHivPositive,
                              location: _locationController.text.trim(),
                            );
                          }
                        },
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
