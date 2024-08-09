import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

enum OnboardingState { page1, page2, page3 }

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingState.page1);

  void goToNextPage() {
    if (state == OnboardingState.page1) {
      emit(OnboardingState.page2);
    } else if (state == OnboardingState.page2) {
      emit(OnboardingState.page3);
    }
  }

  void goToPreviousPage() {
    if (state == OnboardingState.page3) {
      emit(OnboardingState.page2);
    } else if (state == OnboardingState.page2) {
      emit(OnboardingState.page1);
    }
  }
}
