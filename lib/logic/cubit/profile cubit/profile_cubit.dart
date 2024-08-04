import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rakt_pravah/data/repositories/main_repository.dart';

import 'package:rakt_pravah/logic/cubit/profile%20cubit/profile_states.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final MainRepository mainRepository;

  ProfileCubit(this.mainRepository) : super(ProfileInitial());

  Future<void> getProfileDetails() async {
    emit(ProfileLoading());

    try {
      final profileResponse = await mainRepository.fetchProfileDetails();
      emit(ProfileSuccess(profileResponse));
    } catch (e) {
      emit(ProfileError('Failed to fetch profile details: $e'));
    }
  }
}
