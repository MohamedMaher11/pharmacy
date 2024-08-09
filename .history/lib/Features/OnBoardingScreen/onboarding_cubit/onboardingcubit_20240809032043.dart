import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingState(currentPage: 0));

  void updatePage(int page) {
    emit(OnboardingState(currentPage: page));
  }
}

class OnboardingState {
  final int currentPage;

  OnboardingState({required this.currentPage});
}
