import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hamo_pharmacy/Features/OnBoardingScreen/onboarding_cubit/onboardingcubit.dart';
import 'package:hamo_pharmacy/Features/OnBoardingScreen/onboardingscreens/firstscreen.dart';
import 'package:hamo_pharmacy/Features/OnBoardingScreen/onboardingscreens/onboardingbuttonsheet.dart';
import 'package:hamo_pharmacy/Features/OnBoardingScreen/onboardingscreens/secoundscreen.dart';
import 'package:hamo_pharmacy/Features/OnBoardingScreen/onboardingscreens/thirdscreen.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: Scaffold(
        body: BlocBuilder<OnboardingCubit, OnboardingState>(
          builder: (context, state) {
            if (state == OnboardingState.page1) {
              return OnboardingPage1();
            } else if (state == OnboardingState.page2) {
              return OnboardingPage2();
            } else {
              return OnboardingPage3();
            }
          },
        ),
        bottomSheet: OnboardingBottomSheet(),
      ),
    );
  }
}
