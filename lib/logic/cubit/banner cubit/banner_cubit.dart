import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rakt_pravah/data/repositories/main_repository.dart';
import 'package:rakt_pravah/logic/cubit/banner%20cubit/banner_state.dart';

class BannerCubit extends Cubit<BannerState> {
  final MainRepository mainRepository;

  BannerCubit(this.mainRepository) : super(BannerInitialState());

  Future<void> fetchBanner() async {
    emit(BannerLoadingState());

    try {
      final response = await mainRepository.fetchBanner();
      emit(BannerSuccessState(response));
    } catch (e) {
      emit(BannerFailureState(e.toString()));
    }
  }
}
