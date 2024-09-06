import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rakt_pravah/core/api.dart';
import 'package:rakt_pravah/data/models/about_us_response.dart';
import 'package:rakt_pravah/data/models/blood_request_list_response.dart';
import 'package:rakt_pravah/data/models/otp_reponse.dart';
import 'package:rakt_pravah/data/models/profile_response.dart';
import 'package:rakt_pravah/data/models/register_response.dart';
import 'package:rakt_pravah/data/models/verify_otp_response.dart';
import 'package:rakt_pravah/data/models/terms_conditions_response.dart';
import 'package:rakt_pravah/data/models/banner_response.dart';
import 'package:rakt_pravah/logic/services/shared_preferences.dart';

class MainRepository {
  final Api api;

  MainRepository(this.api);

  Future<OtpResponse> requestOtp(String mobile) async {
    try {
      final response = await api.sendRequest.post(
        'request-otp',
        data: FormData.fromMap({'mobile': mobile}),
      );

      if (response.statusCode == 200) {
        return OtpResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to request OTP');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<VerifyOtpResponse> verifyOtp(String mobile, String otp) async {
    try {
      print('Before verify otp');
      final response = await api.sendRequest.post(
        'varify-otp',
        data: FormData.fromMap({'mobile': mobile, 'otp': otp}),
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );
      print('After verify otp');

      if (response.statusCode == 200) {
        // Successful OTP verification
        final responseData = response.data;

        // Handle different success messages for new and existing users
        if (responseData['message']?.toLowerCase().contains('loggedin')) {
          // Parse response data into VerifyOtpResponse model
          final otpResponse = VerifyOtpResponse.fromJson(responseData);

          // Use the token as needed (e.g., store it for future requests)
          final token = otpResponse.token;
          final id = otpResponse.data?.id;

          SharedPreferencesHelper.saveToken(token!);
          SharedPreferencesHelper.saveId(id!);
          return otpResponse;
        } else {
          // Process unexpected message
          throw Exception(
              'Unexpected OTP response: ${responseData['message']}');
        }
      } else if (response.statusCode == 422) {
        // Validation errors
        final errorMessage = response.data['message'];
        if (errorMessage is Map<String, dynamic>) {
          final mobileError = errorMessage['mobile']?.join(', ') ?? '';
          final otpError = errorMessage['otp']?.join(', ') ?? '';
          final combinedErrorMessage =
              [mobileError, otpError].where((s) => s.isNotEmpty).join(' ');
          throw Exception(combinedErrorMessage);
        } else if (errorMessage is String) {
          throw Exception(errorMessage);
        } else {
          throw Exception('Unexpected response format');
        }
      } else if (response.statusCode == 401) {
        // Handle unauthorized and invalid OTP
        throw Exception(response.data['message']);
      } else {
        throw Exception('Failed to verify OTP');
      }
    } catch (e) {
      print('Error details: $e');
      throw 'Invalid OTP or Expired';
    }
  }

  Future<TermsConditionsResponse> fetchTermsAndConditions() async {
    try {
      final response = await api.sendRequest.get('terms-conditions');

      if (response.statusCode == 200) {
        return TermsConditionsResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load terms and conditions');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<TermsConditionsResponse> fetchPrivacyPolicy() async {
    try {
      final response = await api.sendRequest.get('privacy-policy');
      if (response.statusCode == 200) {
        return TermsConditionsResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch privacy policy');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<AboutUsResponse> fetchAboutUs() async {
    try {
      final response = await api.sendRequest.get('about-us');
      if (response.statusCode == 200) {
        return AboutUsResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch About Us data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<RegisterResponse> registerUser({
    required String firstName,
    required String lastName,
    required String mobile,
    required String email,
    required String bloodGroup,
    required String dob,
    required bool tattoo,
    required bool isHivPositive,
    required String? location,
  }) async {
    try {
      int? id = await SharedPreferencesHelper.getId();
      final response = await api.sendRequest.post(
        'register',
        data: FormData.fromMap({
          'id': id,
          'firstname': firstName,
          'lastname': lastName,
          'mobile': mobile,
          'email': email,
          'bloodgroup': bloodGroup,
          'dob': dob,
          'tattoo': tattoo ? 1 : 0,
          'is_hiv_positive': isHivPositive ? 1 : 0,
          'location': location ?? '',
          "registration_status": 1,
        }),
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            // Add other headers if necessary
          },
        ),
      );
      final registorResult = RegisterResponse.fromJson(response.data);

      if (response.statusCode == 201) {
        return registorResult;
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<BannerResponse> fetchBanner() async {
    try {
      final response = await api.sendRequest.get('banners');

      if (response.statusCode == 200) {
        return BannerResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch banner');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<ProfileResponse> fetchProfileDetails() async {
    try {
      int? id = await SharedPreferencesHelper.getId();
      String? token = await SharedPreferencesHelper.getToken();
      final response = await api.sendRequest.get(
        'profile',
        queryParameters: {'user_id': id},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return ProfileResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch profile details');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<BloodRequestListResponse> fetchBloodRequestList() async {
    try {
      int? id = await SharedPreferencesHelper.getId();
      String? token = await SharedPreferencesHelper.getToken();
      final response = await api.sendRequest.get(
        'blood-request-list',
        queryParameters: {'d': id},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return BloodRequestListResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch profile details');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<BloodRequestListResponse> fetchAcceptedBloodRequestList() async {
    try {
      int? id = await SharedPreferencesHelper.getId();
      String? token = await SharedPreferencesHelper.getToken();
      final response = await api.sendRequest.get(
        'accepted-blood-request-list',
        queryParameters: {'id': id},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return BloodRequestListResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch profile details');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<String?> createBloodRequest({
    required String patientFirstName,
    required String patientLastName,
    required String attendeeFirstName,
    required String attendeeLastName,
    required String attendeeMobile,
    required String bloodGroup,
    required String requestType,
    required int numberOfUnits,
    required String requiredDate,
    required String locationForDonation,
    required String hospitalName,
    required bool isCritical,
  }) async {
    try {
      int? id = await SharedPreferencesHelper.getId();
      String? token = await SharedPreferencesHelper.getToken();
      final response = await api.sendRequest.post(
        'blood-request',
        data: FormData.fromMap({
          'user_id': id,
          'patient_f_name': patientFirstName,
          'patient_l_name': patientLastName,
          'attendee_f_name': attendeeFirstName,
          'attendee_l_name': attendeeLastName,
          'attendee_mobile': attendeeMobile,
          'blood_group': bloodGroup,
          'request_type': requestType,
          'no_of_units': numberOfUnits,
          'required_date': requiredDate,
          'location_for_donation': locationForDonation,
          'hospital_name': hospitalName,
          'is_critical': isCritical ? 'yes' : 'no',
        }),
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.statusMessage;
      } else {
        throw Exception('Failed to create blood request');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<String?> editProfile({
    required String name,
    required String mobile,
    required String email,
    required String bloodGroup,
    required String dob,
    required int? tattoo,
    required int? isHivPositive,
    required String location,
    required String? lastDate,
  }) async {
    try {
      int? id = await SharedPreferencesHelper.getId();
      String? token = await SharedPreferencesHelper.getToken();
      final response = await api.sendRequest.post(
        'edit-profile',
        data: FormData.fromMap({
          'user_id': id,
          'name': name,
          'mobile': mobile,
          'email': email,
          'blood_group': bloodGroup,
          'dob': dob,
          'tattoo': tattoo,
          'is_hiv_positive': isHivPositive,
          'location': location,
          'last_date': lastDate ?? ''
        }),
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Authorization': 'Bearer $token',
            // Add other headers if necessary
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.statusMessage;
      } else {
        throw Exception('Failed to Update user');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<String?> uploadProfileImage({
    required File profileImage,
  }) async {
    try {
      String? token = await SharedPreferencesHelper.getToken();
      int? id = await SharedPreferencesHelper.getId();
      final formData = FormData.fromMap({
        'user_id': id,
        'profile_image': await MultipartFile.fromFile(profileImage.path),
      });

      final response = await api.sendRequest.post(
        'user-profile-upload',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          return data['message'];
        } else {
          throw Exception('Failed to upload profile image');
        }
      } else {
        throw Exception('Failed to upload profile image');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
