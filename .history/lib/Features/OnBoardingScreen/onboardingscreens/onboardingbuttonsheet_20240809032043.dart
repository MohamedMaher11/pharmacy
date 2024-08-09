import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hamo_pharmacy/Features/OnBoardingScreen/onboarding_cubit/onboardingcubit.dart';

class OnboardingBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OnboardingCubit>();

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [],
      ),
    );
  }
}
