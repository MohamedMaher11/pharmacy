import 'package:bloc/bloc.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingState(page: 0));

  void updatePage(int page) {
    emit(OnboardingState(page: page));
  }
}

class OnboardingState {
  final int page;

  OnboardingState({required this.page});
}
