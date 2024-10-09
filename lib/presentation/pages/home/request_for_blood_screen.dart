import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rakt_pravah/core/api.dart';
import 'package:rakt_pravah/core/ui.dart';
import 'package:rakt_pravah/data/repositories/main_repository.dart';
import 'package:rakt_pravah/logic/services/shared_preferences.dart';
import 'package:rakt_pravah/presentation/pages/home/dashboard_screen.dart';
import 'package:rakt_pravah/presentation/pages/home/home_page.dart';
import 'package:rakt_pravah/presentation/pages/other/privacy_prolicy.dart';
import 'package:rakt_pravah/presentation/pages/other/terms_conditions.dart';
import 'package:rakt_pravah/presentation/widgets/custom_dialog_box.dart';
import 'package:rakt_pravah/presentation/widgets/gap_widget.dart';
import 'package:rakt_pravah/presentation/widgets/link_button.dart';
import 'package:rakt_pravah/presentation/widgets/primary_button.dart';
import 'package:rakt_pravah/presentation/widgets/primary_textfield.dart';

class RequestForBloodScreen extends StatefulWidget {
  const RequestForBloodScreen({super.key});
  static const String routeName = "RequestForBlood";

  @override
  State<RequestForBloodScreen> createState() => _RequestForBloodScreenState();
}

class _RequestForBloodScreenState extends State<RequestForBloodScreen> {
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _attendeeMobileController =
      TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _hospitalNameController = TextEditingController();
  final TextEditingController _additionalNoteController =
      TextEditingController();
  final MainRepository mainRepository = MainRepository(Api());

  String? _selectedBloodType;
  String? _selectedBloodGroup;
  String? _selectedUnits;
  DateTime? _selectedDate;
  bool _isCritical = false;
  bool _agreedToTerms = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPhoneNumber();
  }

  Future<void> _loadPhoneNumber() async {
    // Fetch phone number from SharedPreferences
    String? phoneNumber = await SharedPreferencesHelper.getPhoneNumber();

    // Update the controller's text
    _attendeeMobileController.text = phoneNumber ?? '';
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _patientNameController.dispose();
    _attendeeMobileController.dispose();
    _locationController.dispose();
    _hospitalNameController.dispose();
    _additionalNoteController.dispose();
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

  Future<void> _handleFormSubmission() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Collect form data
      final patientName = _patientNameController.text.split(' ');
      final attendeeName = _attendeeMobileController.text.split(' ');
      final requestType = _selectedBloodType ?? '';
      final bloodGroup = _selectedBloodGroup ?? '';
      final numberOfUnits =
          int.tryParse(_selectedUnits?.split(' ')[0] ?? '0') ?? 0;
      final requiredDate = _selectedDate != null
          ? '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}'
          : '';

      final locationForDonation = _locationController.text;
      final hospitalName = _hospitalNameController.text;
      try {
        final result = await mainRepository.createBloodRequest(
          patientFirstName: patientName[0],
          patientLastName: patientName.length > 1 ? patientName[1] : '',
          attendeeFirstName: attendeeName[0],
          attendeeLastName: attendeeName.length > 1 ? attendeeName[1] : '',
          attendeeMobile: _attendeeMobileController.text,
          bloodGroup: bloodGroup,
          requestType: requestType,
          numberOfUnits: numberOfUnits,
          requiredDate: requiredDate,
          locationForDonation: locationForDonation,
          hospitalName: hospitalName,
          isCritical: _isCritical,
        );

        // Show success dialog
        _showCustomDialog(
          context,
          'Request Sent',
          'Your blood request has been successfully sent.',
          () {
            Navigator.pop(context);
          },
        );
      } catch (e) {
        // Handle errors
        _showCustomDialog(
          context,
          'Error',
          'There was an error sending your request. Please try again later.',
          () {
            Navigator.pop(context);
          },
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
          title: const Text('Request For Blood'),
          backgroundColor: AppColors.primaryColor,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '(Kindly Fill The Details Correctly To Help You Better)',
                      style: TextStyles.body2,
                    ),
                    const GapWidget(size: 10),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        hintText: 'Select Blood Type',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      ),
                      value: _selectedBloodType,
                      items: const [
                        DropdownMenuItem(value: 'Blood', child: Text('Blood')),
                        DropdownMenuItem(
                            value: 'Platelets', child: Text('Platelets')),
                        // Add other blood types if needed
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedBloodType = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select the blood type';
                        }
                        return null;
                      },
                    ),
                    const GapWidget(),
                    PrimaryTextField(
                      hintText: 'Patient Name',
                      icon: Icons.person,
                      controller: _patientNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the patient name';
                        }
                        return null;
                      },
                    ),
                    const GapWidget(),
                    PrimaryTextField(
                      hintText: 'Attendee Mobile Number',
                      icon: Icons.phone,
                      controller: _attendeeMobileController,
                      enabled: false,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the attendee mobile number';
                        }
                        if (value.length != 10) {
                          return 'Please enter a valid 10-digit mobile number';
                        }
                        return null;
                      },
                    ),
                    const GapWidget(),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        hintText: 'Select Blood Group',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      ),
                      value: _selectedBloodGroup,
                      items: const [
                        DropdownMenuItem(value: 'A+', child: Text('A+')),
                        DropdownMenuItem(value: 'A-', child: Text('A-')),
                        DropdownMenuItem(value: 'B+', child: Text('B+')),
                        DropdownMenuItem(value: 'B-', child: Text('B-')),
                        DropdownMenuItem(value: 'AB+', child: Text('AB+')),
                        DropdownMenuItem(value: 'AB-', child: Text('AB-')),
                        DropdownMenuItem(value: 'O+', child: Text('O+')),
                        DropdownMenuItem(value: 'O-', child: Text('O-')),
                        DropdownMenuItem(value: 'A1+', child: Text('A1+')),
                        DropdownMenuItem(value: 'A1-', child: Text('A1-')),
                        DropdownMenuItem(value: 'A2+', child: Text('A2+')),
                        DropdownMenuItem(value: 'A2-', child: Text('A2-')),
                        DropdownMenuItem(value: 'A1B+', child: Text('A1B+')),
                        DropdownMenuItem(value: 'A1B-', child: Text('A1B-')),
                        DropdownMenuItem(value: 'A2B+', child: Text('A2B+')),
                        DropdownMenuItem(value: 'A2B-', child: Text('A2B-')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedBloodGroup = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select the blood group';
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
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
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
                            _selectedDate = pickedDate;
                          });
                        }
                      },
                      child: PrimaryTextField(
                        hintText: 'Required Date',
                        icon: Icons.date_range,
                        controller: TextEditingController(
                          text: _selectedDate != null
                              ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                              : '',
                        ),
                        enabled: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a date';
                          }
                          return null;
                        },
                      ),
                    ),
                    const GapWidget(),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        hintText: 'Select Units',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      ),
                      value: _selectedUnits,
                      items: const [
                        DropdownMenuItem(
                            value: '1 Unit', child: Text('1 Unit')),
                        DropdownMenuItem(
                            value: '2 Units', child: Text('2 Units')),
                        DropdownMenuItem(
                            value: '3 Units', child: Text('3 Units')),
                        DropdownMenuItem(
                            value: '4 Units', child: Text('4 Units')),
                        DropdownMenuItem(
                            value: '5 Units', child: Text('5 Units')),
                        DropdownMenuItem(
                            value: '6 Units', child: Text('6 Units')),
                        DropdownMenuItem(
                            value: '7 Units', child: Text('7 Units')),
                        DropdownMenuItem(
                            value: '8 Units', child: Text('8 Units')),
                        DropdownMenuItem(
                            value: '9 Units', child: Text('9 Units')),
                        // Add other units if needed
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedUnits = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select the units';
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
                    PrimaryTextField(
                      hintText: 'Hospital Name',
                      icon: Icons.local_hospital,
                      controller: _hospitalNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the hospital name';
                        }
                        return null;
                      },
                    ),
                    const GapWidget(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Critical', style: TextStyles.body3),
                        Switch(
                          value: _isCritical,
                          onChanged: (value) {
                            setState(() {
                              _isCritical = value;
                            });
                          },
                        ),
                      ],
                    ),
                    const GapWidget(),
                    PrimaryTextField(
                      hintText: 'Additional Note to Potential Donor',
                      icon: Icons.note,
                      controller: _additionalNoteController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please add any additional notes';
                        }
                        return null;
                      },
                    ),
                    const GapWidget(size: 10),
                    Row(
                      children: [
                        Checkbox(
                          value: _agreedToTerms,
                          onChanged: (value) {
                            setState(() {
                              _agreedToTerms = value!;
                            });
                          },
                        ),
                        Text(
                          'I have read and agree to these ',
                          style: TextStyles.body3,
                        ),
                      ],
                    ),
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
                    _isLoading
                        ? CircularProgressIndicator()
                        : PrimaryButton(
                            text: 'Send Request',
                            onPressed: _handleFormSubmission,
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
