import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hamo_pharmacy/Features/OnBoardingScreen/onboarding_cubit/onboardingcubit.dart';

class OnboardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  OnboardingPage({
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OnboardingCubit>();
    final isCurrentPage = cubit.state.page == cubit.state.page;

    return Column(
      children: [
        Expanded(
          flex: 4,
          child: AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            left: isCurrentPage ? 0 : MediaQuery.of(context).size.width,
            right: isCurrentPage ? 0 : -MediaQuery.of(context).size.width,
            top: MediaQuery.of(context).size.height * 0.1, // تحريك الصورة لأعلى
            child: Center(
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 500),
                opacity: isCurrentPage ? 1 : 0,
                child: Image.asset(imagePath, height: 300), // حجم الصورة
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                  fontFamily: 'Roboto',
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20), // زيادة المسافة بين العنوان والوصف
              Text(
                description,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                  fontFamily: 'Roboto',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Spacer(),

        SizedBox(height: 20), // مسافة إضافية أسفل الزرار
      ],
    );
  }
}
