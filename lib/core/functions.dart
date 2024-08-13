import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
