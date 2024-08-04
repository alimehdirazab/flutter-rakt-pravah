import 'package:rakt_pravah/data/models/profile_response.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final ProfileResponse profileResponse;

  ProfileSuccess(this.profileResponse);
}

class ProfileError extends ProfileState {
  final String errorMessage;

  ProfileError(this.errorMessage);
}
