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
    final currentPage = cubit.state.page;

    // Get the index of the current page
    final isCurrentPage = currentPage == cubit.state.page;

    return AnimatedBuilder(
      animation: PageController(),
      builder: (context, child) {
        return Stack(
          children: [
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              left: isCurrentPage ? 0 : MediaQuery.of(context).size.width,
              right: isCurrentPage ? 0 : -MediaQuery.of(context).size.width,
              top: MediaQuery.of(context).size.height * 0.2,
              child: Center(
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 500),
                  opacity: isCurrentPage ? 1 : 0,
                  child: Image.asset(imagePath, height: 300),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 700),
              curve: Curves.easeInOut,
              left: isCurrentPage ? 20 : MediaQuery.of(context).size.width,
              right: isCurrentPage ? 20 : -MediaQuery.of(context).size.width,
              bottom: MediaQuery.of(context).size.height * 0.25,
              child: Column(
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    description,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
