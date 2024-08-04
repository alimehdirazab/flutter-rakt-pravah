import 'package:rakt_pravah/data/models/banner_response.dart';

abstract class BannerState {}

class BannerInitialState extends BannerState {}

class BannerLoadingState extends BannerState {}

class BannerSuccessState extends BannerState {
  final BannerResponse response;

  BannerSuccessState(this.response);
}

class BannerFailureState extends BannerState {
  final String error;

  BannerFailureState(this.error);
}
