import 'package:dio/dio.dart';
import 'package:rakt_pravah/core/api.dart';
import 'package:rakt_pravah/data/models/about_us_response.dart';
import 'package:rakt_pravah/data/models/otp_reponse.dart';
import 'package:rakt_pravah/data/models/register_response.dart';
import 'package:rakt_pravah/data/models/verify_otp_response.dart';
import 'package:rakt_pravah/data/models/terms_conditions_response.dart';
import 'package:rakt_pravah/data/models/banner_response.dart';

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
            // Add any other required headers here
          },
        ),
      );
      print('After verify otp');

      if (response.statusCode == 200) {
        // Successful OTP verification
        final responseData = response.data;
        if (responseData['message']?.toLowerCase() == 'loggedin successfull') {
          // Parse response data into VerifyOtpResponse model
          final otpResponse = VerifyOtpResponse.fromJson(responseData);

          // Use the token as needed (e.g., store it for future requests)
          final token = otpResponse.token;
          print('Token: $token');

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
          // Handle specific error messages for fields
          final mobileError = errorMessage['mobile']?.join(', ') ?? '';
          final otpError = errorMessage['otp']?.join(', ') ?? '';
          final combinedErrorMessage =
              [mobileError, otpError].where((s) => s.isNotEmpty).join(' ');
          throw Exception(combinedErrorMessage);
        } else if (errorMessage is String) {
          // Handle general error message
          throw Exception(errorMessage);
        } else {
          throw Exception('Unexpected response format');
        }
      } else if (response.statusCode == 401) {
        // Handle unauthorized and invalid OTP
        if (response.data['message'] == 'Invalid OTP') {
          throw Exception(response.data['message']);
        } else {
          throw Exception('Unauthorized access - please try again.');
        }
      } else {
        throw Exception('Failed to verify OTP');
      }
    } catch (e) {
      print('Error details: $e');
      throw Exception('Error: $e');
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
    required String location,
  }) async {
    try {
      final response = await api.sendRequest.post(
        'register',
        data: FormData.fromMap({
          'firstname': firstName,
          'lastname': lastName,
          'mobile': mobile,
          'email': email,
          'bloodgroup': bloodGroup,
          'dob': dob,
          'tattoo': tattoo ? 'yes' : 'no',
          'is_hiv_positive': isHivPositive ? 'yes' : 'no',
          'location': location,
          "registration_status": 1,
        }),
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            // Add other headers if necessary
          },
        ),
      );

      if (response.statusCode == 201) {
        return RegisterResponse.fromJson(response.data);
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
}