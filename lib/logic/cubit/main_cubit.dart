import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rakt_pravah/data/models/blood_request_list_response.dart';
import 'package:rakt_pravah/data/repositories/main_repository.dart';
import 'package:rakt_pravah/logic/cubit/main_states.dart';

class MainCubit extends Cubit<MainState> {
  final MainRepository mainRepository;

  MainCubit(this.mainRepository) : super(InitialState());

  Future<void> requestOtp(String mobile) async {
    emit(OtpLoadingState());

    try {
      final response = await mainRepository.requestOtp(mobile);

      if (response.message != null) {
        // If the response contains a simple success message
        emit(OtpSuccessState(response));
      } else if (response.errorMessages != null) {
        // If there are validation error messages
        final errorMessages =
            response.errorMessages!.values.expand((e) => e).join(', ');
        emit(OtpFailureState(errorMessages));
      } else {
        emit(OtpFailureState('Unknown error occurred'));
      }
    } catch (e) {
      emit(OtpFailureState(e.toString()));
    }
  }

  Future<void> verifyOtp(String mobile, String otp) async {
    emit(VerifyOtpLoadingState());

    try {
      final response = await mainRepository.verifyOtp(mobile, otp);
      emit(VerifyOtpSuccessState(response));
    } catch (e) {
      // Handle specific errors
      if (e.toString().contains('Invalid OTP')) {
        emit(VerifyOtpFailureState('Invalid OTP'));
      } else {
        emit(VerifyOtpFailureState(e.toString()));
      }
    }
  }

  Future<void> fetchTermsAndConditions() async {
    emit(TermsLoadingState());

    try {
      final response = await mainRepository.fetchTermsAndConditions();
      emit(TermsSuccessState(response));
    } catch (e) {
      emit(TermsFailureState(e.toString()));
    }
  }

  Future<void> fetchPrivacyPolicy() async {
    emit(PrivacyPolicyLoadingState());

    try {
      final response = await mainRepository.fetchPrivacyPolicy();
      emit(PrivacyPolicySuccessState(response));
    } catch (e) {
      emit(PrivacyPolicyFailureState(e.toString()));
    }
  }

  Future<void> fetchAboutUs() async {
    emit(AboutUsLoadingState());

    try {
      final response = await mainRepository.fetchAboutUs();
      emit(AboutUsSuccessState(response));
    } catch (e) {
      emit(AboutUsFailureState(e.toString()));
    }
  }

  Future<void> registerUser({
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
    emit(RegisterLoadingState());

    try {
      final response = await mainRepository.registerUser(
        firstName: firstName,
        lastName: lastName,
        mobile: mobile,
        email: email,
        bloodGroup: bloodGroup,
        dob: dob,
        tattoo: tattoo,
        isHivPositive: isHivPositive,
        location: location,
      );

      emit(RegisterSuccessState(response));
    } catch (e) {
      emit(RegisterFailureState(e.toString()));
    }
  }

  Future<void> getBloodRequestList() async {
    emit(BloodRequestListLoading());

    try {
      final response = await mainRepository.fetchBloodRequestList();
      emit(BloodRequestListSuccess(response));
    } catch (e) {
      emit(BloodRequestListError(
          'Failed to fetch BloodRequestList details: $e'));
    }
  }

  Future<void> getAcceptedBloodRequestList() async {
    emit(AcceptedBloodRequestListLoading());

    try {
      final response = await mainRepository.fetchAcceptedBloodRequestList();
      emit(AcceptedBloodRequestListSuccess(response));
    } catch (e) {
      emit(AcceptedBloodRequestListError(
          'Failed to fetch Accepted BloodRequestList details: $e'));
    }
  }
}
