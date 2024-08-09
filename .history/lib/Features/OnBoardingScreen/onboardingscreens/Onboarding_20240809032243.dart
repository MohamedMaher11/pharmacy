import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hamo_pharmacy/Features/OnBoardingScreen/onboarding_cubit/onboardingcubit.dart';
import 'package:hamo_pharmacy/Features/OnBoardingScreen/onboardingscreens/onboardingpage.dart';
import 'package:hamo_pharmacy/gen/assets.gen.dart';

class OnboardingScreen extends StatelessWidget {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingCubit(),
      child: Scaffold(
        body: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: (index) {
                context.read<OnboardingCubit>().updatePage(index);
              },
              children: [
                OnboardingPage(
                  imagePath: Assets.pharmacy.path,
                  title: 'Welcome to Your Pharmacy',
                  description:
                      'Your health is our priority. Get all the medicines and medical consultations you need.',
                ),
                OnboardingPage(
                  imagePath: Assets.medecin.path,
                  title: 'Explore Our Medicines',
                  description:
                      'Find all the medicines you need with detailed information and availability.',
                ),
                OnboardingPage(
                  imagePath: Assets.consult.path,
                  title: 'Medical Consultations',
                  description:
                      'Get in touch with our doctors for quick and reliable medical advice.',
                ),
              ],
            ),
            Positioned(
              top: 40,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/signup');
                },
                child: Text(
                  'Skip',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  final cubit = context.read<OnboardingCubit>();
                  if (cubit.state.currentPage < 2) {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    Navigator.pushReplacementNamed(context, '/signup');
                  }
                },
                child: Text(
                  'Next',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
