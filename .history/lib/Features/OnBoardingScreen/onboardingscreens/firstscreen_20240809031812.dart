import 'package:flutter/widgets.dart';
import 'package:hamo_pharmacy/gen/assets.gen.dart';

class OnboardingPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Assets.pharmacy.path, height: 200), // صورة
            SizedBox(height: 20),
            Text(
              'Welcome to Your Pharmacy',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Your health is our priority. Get all the medicines and medical consultations you need.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
