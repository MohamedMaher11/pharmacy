import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hamo_pharmacy/gen/assets.gen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget buildTextField(
  TextEditingController controller,
  String label, {
  bool obscureText = false,
  Widget? suffixIcon,
}) {
  return TextFormField(
    controller: controller,
    obscureText: obscureText,
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      suffixIcon: suffixIcon,
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your $label';
      } else if (label == 'Email' &&
          !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
        return 'Please enter a valid email address';
      }
      return null;
    },
  );
}

String getFriendlyErrorMessage(String error) {
  if (error.contains('user-not-found')) {
    return 'No user found with this email.';
  } else if (error.contains('wrong-password')) {
    return 'Incorrect password.';
  } else if (error.contains('invalid-email')) {
    return 'The email address is not valid.';
  } else {
    return 'An unknown error occurred. Please try again.';
  }
}

Widget buildTextFieldDoctor({
  required TextEditingController controller,
  required String label,
  String? Function(String?)? validator,
  bool obscureText = false,
  Widget? suffixIcon,
  TextInputType keyboardType = TextInputType.text,
}) {
  return TextFormField(
    controller: controller,
    obscureText: obscureText,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      suffixIcon: suffixIcon,
    ),
    validator: validator,
  );
}

Future<void> checkLoginStatus(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  if (isLoggedIn) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }
}

Widget getCategoryImage(String categoryName) {
  switch (categoryName) {
    case 'السعال':
      return Image.asset(Assets.coughh.path, height: 50);
    case 'تخفيف الألم':
      return Image.asset(Assets.pain.path, height: 50);
    case 'العناية بالبشرة':
      return Image.asset(Assets.skincare.path, height: 50);
    case 'الصداع':
      return Image.asset(Assets.headache.path, height: 50);
    case 'الحمى':
      return Image.asset(Assets.fever.path, height: 50);

    case 'العناية بالأسنان':
      return Image.asset(Assets.dentist.path, height: 50);
    default:
      return Image.asset('assets/images/default.png',
          height: 50); // صورة افتراضية
  }
}

TextStyle fontcolor() {
  return fontcolor();
  ;
}
