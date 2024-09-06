import 'package:flutter/material.dart';
import 'package:rakt_pravah/core/api.dart';
import 'package:rakt_pravah/core/ui.dart';
import 'package:rakt_pravah/data/models/profile_response.dart';
import 'package:rakt_pravah/data/repositories/main_repository.dart';
import 'package:rakt_pravah/logic/services/shared_preferences.dart';
import 'package:rakt_pravah/presentation/pages/home/home_page.dart';
import 'package:rakt_pravah/presentation/pages/other/my_profile_screen.dart';
import 'package:rakt_pravah/presentation/pages/other/privacy_prolicy.dart';
import 'package:rakt_pravah/presentation/pages/other/terms_conditions.dart';
import 'package:rakt_pravah/presentation/widgets/custom_dialog_box.dart';
import 'package:rakt_pravah/presentation/widgets/gap_widget.dart';
import 'package:rakt_pravah/presentation/widgets/link_button.dart';
import 'package:rakt_pravah/presentation/widgets/primary_button.dart';
import 'package:rakt_pravah/presentation/widgets/primary_textfield.dart';

class EditProfile extends StatefulWidget {
  final ProfileData? profileData; // ProfileData is now nullable
  const EditProfile({super.key, this.profileData});
  static const String routeName = "EditProfile";

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  // Define controllers for form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _lastDonationController = TextEditingController();

  int _tattoo = 0; // Checkbox state for tattoo
  int _isHivPositive = 0; // Checkbox state for HIV

  String? _selectedBloodGroup; // Store selected blood group

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Set the initial value of controllers to profileData values
    final ProfileData? data = widget.profileData;

    if (data != null) {
      _nameController.text = data.name ?? '';
      _mobileController.text = data.mobile ?? '';
      _emailController.text = data.email ?? '';
      _selectedBloodGroup = data.bloodGroup ?? '';
      _dobController.text = data.dob ?? '';
      _tattoo = data.tattoo ?? 0;
      _isHivPositive = data.isHivPositive ?? 0;
      _locationController.text = data.location ?? '';
      _lastDonationController.text = data.lastDate ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _locationController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _lastDonationController.dispose();
    super.dispose();
  }

  // Function to show a custom dialog
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

  // Function to handle the edit profile submission
  Future<void> _submitEditProfile() async {
    if (_formKey.currentState!.validate()) {
      // Show a loading indicator
      _showLoadingIndicator(context);
      final tattooValue = _tattoo;
      final isHivPositiveValue = _isHivPositive;
      print('Tattoo: $tattooValue');
      print('HIV: $isHivPositiveValue');

      try {
        String? responseMessage = await MainRepository(Api()).editProfile(
          name: _nameController.text.trim(),
          mobile: _mobileController.text.trim(),
          email: _emailController.text.trim(),
          bloodGroup: _selectedBloodGroup!,
          dob: _dobController.text.trim(),
          tattoo: tattooValue,
          isHivPositive: isHivPositiveValue,
          location: _locationController.text.trim(),
          lastDate: _lastDonationController.text.trim(),
        );

        // Hide the loading indicator
        Navigator.pop(context);

        if (responseMessage != null) {
          _showCustomDialog(
            context,
            "Successfully Updated",
            'Profile Details Successfully Updated',
            () {
              Navigator.pushReplacementNamed(
                  context, MyProfileScreen.routeName);
            },
          );
        } else {
          throw Exception('Unknown error occurred while updating profile');
        }
      } catch (e) {
        // Hide the loading indicator
        Navigator.pop(context);

        // Show an error dialog if something went wrong
        _showCustomDialog(context, 'Error', e.toString(), () {
          Navigator.pop(context);
        });
      }
    }
  }

  // Function to show a loading indicator
  void _showLoadingIndicator(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  // Function to select date using a date picker
  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        controller.text =
            '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                PrimaryTextField(
                  controller: _nameController,
                  hintText: 'Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                PrimaryTextField(
                  controller: _mobileController,
                  hintText: 'Mobile Number',
                  keyboardType: TextInputType.phone,
                  enabled: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your mobile number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                PrimaryTextField(
                  controller: _emailController,
                  hintText: 'Email Address',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
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
                      child: Text('A2B-'),
                    ),
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedBloodGroup = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your blood group';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _selectDate(context, _dobController),
                  child: PrimaryTextField(
                    controller: _dobController,
                    hintText: 'Date of Birth',
                    enabled: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your date of birth';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 10),
                PrimaryTextField(
                  controller: _locationController,
                  hintText: 'Location',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your location';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _selectDate(context, _lastDonationController),
                  child: PrimaryTextField(
                    controller: _lastDonationController,
                    hintText: 'Last Blood Donation Date',
                    enabled: false,
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please select your date of birth';
                    //   }
                    //   return null;
                    // },
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _tattoo == 1,
                      onChanged: (bool? value) {
                        setState(() {
                          _tattoo = value! ? 1 : 0;
                        });
                      },
                    ),
                    Text('Do you have a tattoo?'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _isHivPositive == 1,
                      onChanged: (bool? value) {
                        setState(() {
                          _isHivPositive = value! ? 1 : 0;
                        });
                      },
                    ),
                    Text('Are you HIV positive?'),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LinkButton(
                      text: 'Terms & Conditions',
                      onPressed: () {
                        Navigator.pushNamed(context, TermsConditions.routeName);
                      },
                    ),
                    Text('  and  '),
                    LinkButton(
                      text: 'Privacy Policy',
                      onPressed: () {
                        Navigator.pushNamed(context, PrivacyPolicy.routeName);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                PrimaryButton(
                  text: 'Submit',
                  onPressed: _submitEditProfile,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
