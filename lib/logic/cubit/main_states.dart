import 'package:rakt_pravah/data/models/about_us_response.dart';
import 'package:rakt_pravah/data/models/banner_response.dart';
import 'package:rakt_pravah/data/models/blood_request_list_response.dart';
import 'package:rakt_pravah/data/models/otp_reponse.dart';
import 'package:rakt_pravah/data/models/profile_response.dart';
import 'package:rakt_pravah/data/models/register_response.dart';
import 'package:rakt_pravah/data/models/terms_conditions_response.dart';
import 'package:rakt_pravah/data/models/verify_otp_response.dart';

abstract class MainState {}

class InitialState extends MainState {}

class OtpLoadingState extends MainState {}

class OtpSuccessState extends MainState {
  final OtpResponse response;

  OtpSuccessState(this.response);
}

class OtpFailureState extends MainState {
  final String error;

  OtpFailureState(this.error);
}

/////////////////////////////////////////
class VerifyOtpLoadingState extends MainState {}

class VerifyOtpSuccessState extends MainState {
  final VerifyOtpResponse response;

  VerifyOtpSuccessState(this.response);
}

class VerifyOtpFailureState extends MainState {
  final String error;

  VerifyOtpFailureState(this.error);
}

/////////////////////////////////////////

class TermsLoadingState extends MainState {}

class TermsSuccessState extends MainState {
  final TermsConditionsResponse response;

  TermsSuccessState(this.response);
}

class TermsFailureState extends MainState {
  final String error;

  TermsFailureState(this.error);
}

//////////////////////////////////////////////

class PrivacyPolicyLoadingState extends MainState {}

class PrivacyPolicySuccessState extends MainState {
  final TermsConditionsResponse response;

  PrivacyPolicySuccessState(this.response);
}

class PrivacyPolicyFailureState extends MainState {
  final String error;

  PrivacyPolicyFailureState(this.error);
}

///////////////////////////////////////////////

class AboutUsLoadingState extends MainState {}

class AboutUsSuccessState extends MainState {
  final AboutUsResponse response;

  AboutUsSuccessState(this.response);
}

class AboutUsFailureState extends MainState {
  final String error;

  AboutUsFailureState(this.error);
}

//////////////////////////////////////////////

class RegisterLoadingState extends MainState {}

class RegisterSuccessState extends MainState {
  final RegisterResponse response;

  RegisterSuccessState(this.response);
}

class RegisterFailureState extends MainState {
  final String error;

  RegisterFailureState(this.error);
}

//////////////////////////////////////////////

class BloodRequestListLoading extends MainState {}

class BloodRequestListSuccess extends MainState {
  final BloodRequestListResponse bloodRequestListResponse;

  BloodRequestListSuccess(this.bloodRequestListResponse);
}

class BloodRequestListError extends MainState {
  final String errorMessage;

  BloodRequestListError(this.errorMessage);
}

//////////////////////////////////////////////////////

class AcceptedBloodRequestListLoading extends MainState {}

class AcceptedBloodRequestListSuccess extends MainState {
  final BloodRequestListResponse bloodRequestListResponse;

  AcceptedBloodRequestListSuccess(this.bloodRequestListResponse);
}

class AcceptedBloodRequestListError extends MainState {
  final String errorMessage;

  AcceptedBloodRequestListError(this.errorMessage);
}

//////////////////////////////////////////////////////
class ProfileImageLoading extends MainState {}

class ProfileImageSuccess extends MainState {
  final String message;

  ProfileImageSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfileImageError extends MainState {
  final String errorMessage;

  ProfileImageError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
