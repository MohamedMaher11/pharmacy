import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hamo_pharmacy/Features/Auth/Signupcubit/singupcubit.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneSignupScreen extends StatelessWidget {
  final TextEditingController _phoneController = TextEditingController();
  String initialCountry = 'EG'; // الدولة الافتراضية
  PhoneNumber number = PhoneNumber(isoCode: 'EG'); // صيغة الرقم الافتراضي

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up with Phone'),
      ),
      body: BlocListener<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state is SignupCodeSent) {
            Navigator.pushNamed(context, '/phone_verify');
          } else if (state is SignupFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter your phone number',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              SizedBox(height: 40),
              InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                  _phoneController.text = number.phoneNumber ?? '';
                },
                onInputValidated: (bool isValid) {
                  if (!isValid) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Invalid phone number format.')),
                    );
                  }
                },
                selectorConfig: SelectorConfig(
                  selectorType: PhoneInputSelectorType.DROPDOWN,
                ),
                ignoreBlank: true,
                autoValidateMode:
                    AutovalidateMode.disabled, // تعطيل التحقق التلقائي
                selectorTextStyle: TextStyle(color: Colors.black),
                initialValue: number,
                textFieldController: _phoneController,
                formatInput:
                    false, // تعطيل تنسيق الإدخال للسماح بإدخال الرقم بدون مشاكل
                inputDecoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.phone,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (_phoneController.text.isNotEmpty) {
                    context.read<SignupCubit>().signupWithPhone(
                          _phoneController.text,
                        );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Please enter a valid phone number')),
                    );
                  }
                },
                child: Text(
                  'Next',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
