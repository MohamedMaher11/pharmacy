import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart'; // أضف هذه السطر
import 'package:hamo_pharmacy/Features/Auth/Signupcubit/singupcubit.dart';
import 'package:hamo_pharmacy/Features/HomeScreen/views/Home.dart';
import 'package:hamo_pharmacy/gen/assets.gen.dart';
import 'package:image_picker/image_picker.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  XFile? _profileImage;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profileImage = pickedFile;
    });
  }

  void _signUp(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<SignupCubit>().signupWithEmail(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            name: _nameController.text.trim(),
            profileImage: _profileImage,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تسجيل حساب'),
        backgroundColor: Colors.deepPurple,
      ),
      body: BlocListener<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state is SignupSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else if (state is SignupFailure) {
            _showErrorDialog(context, _getFriendlyErrorMessage(state.error));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Text(
                  'أنشئ حسابك',
                  style: GoogleFonts.cairo(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                SizedBox(height: 16),
                _buildTextField(_emailController, 'البريد الإلكتروني'),
                SizedBox(height: 16),
                _buildTextField(
                  _passwordController,
                  'كلمة المرور',
                  obscureText: _obscureText,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
                SizedBox(height: 16),
                _buildTextField(_nameController, 'الاسم'),
                SizedBox(height: 16),
                _buildProfileImagePicker(),
                SizedBox(height: 32),
                SizedBox(
                  width: double.infinity, // تعديل هنا
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => _signUp(context),
                    child: Text(
                      'تسجيل',
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.center, // تعديل هنا
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/signup_doctor');
                    },
                    child: Text(
                      'تسجيل كطبيب',
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.center, // تعديل هنا
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/sign_in');
                    },
                    child: Text(
                      'لديك حساب بالفعل؟ تسجيل الدخول',
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        color: Colors.blue[800],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
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
          return 'يرجى إدخال $label';
        } else if (label == 'البريد الإلكتروني' &&
            !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'يرجى إدخال بريد إلكتروني صحيح';
        } else if (label == 'كلمة المرور' && value.length < 6) {
          return 'يجب أن تكون كلمة المرور على الأقل 6 أحرف';
        }
        return null;
      },
    );
  }

  Widget _buildProfileImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: CircleAvatar(
        radius: 50,
        backgroundImage:
            _profileImage != null ? FileImage(File(_profileImage!.path)) : null,
        child: _profileImage == null
            ? Icon(FontAwesomeIcons.camera, size: 50, color: Colors.grey[800])
            : null,
      ),
    );
  }

  String _getFriendlyErrorMessage(String error) {
    if (error.contains('email-already-in-use')) {
      return 'البريد الإلكتروني هذا مستخدم بالفعل.';
    } else if (error.contains('weak-password')) {
      return 'كلمة المرور ضعيفة جداً.';
    } else if (error.contains('invalid-email')) {
      return 'عنوان البريد الإلكتروني غير صالح.';
    } else {
      return 'حدث خطأ غير معروف. يرجى المحاولة مرة أخرى.';
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 8),
              Text('خطأ'),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('موافق'),
            ),
          ],
        );
      },
    );
  }
}
