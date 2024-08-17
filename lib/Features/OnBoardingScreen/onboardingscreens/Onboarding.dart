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
                  controller: _pageController,
                  imagePath: Assets.pharmacy.path,
                  title: 'مرحبا بكم في صيدليتكم',
                  description:
                      'صحتكم هي أولويتنا. احصلوا على جميع الأدوية والاستشارات الطبية التي تحتاجونها.',
                ),
                OnboardingPage(
                  controller: _pageController,
                  imagePath: Assets.medecin.path,
                  title: 'استكشف أدويتنا',
                  description:
                      'ابحثوا عن جميع الأدوية التي تحتاجونها مع معلومات تفصيلية وتوافرها.',
                ),
                OnboardingPage(
                  controller: _pageController,
                  imagePath: Assets.consult.path,
                  title: 'استشارات طبية',
                  description:
                      'تواصلوا مع أطبائنا للحصول على نصائح طبية سريعة وموثوقة.',
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
                  'تخطي',
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
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  final cubit = context.read<OnboardingCubit>();
                  if (cubit.state.page < 2) {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    Navigator.pushReplacementNamed(context, '/signup');
                  }
                },
                child: Text(
                  'التالي',
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
