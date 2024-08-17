import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hamo_pharmacy/Features/Auth/SignupDoctor/signupcubit.dart';
import 'package:hamo_pharmacy/gen/assets.gen.dart';
import 'package:image_picker/image_picker.dart';

class SignupDoctorScreen extends StatefulWidget {
  @override
  _SignupDoctorScreenState createState() => _SignupDoctorScreenState();
}

class _SignupDoctorScreenState extends State<SignupDoctorScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _selectedSpecialty = 'طب الأطفال'; // التخصص الافتراضي
  XFile? _profileImage;
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null && await pickedFile.length() < 5 * 1024 * 1024) {
      // حجم الصورة أقل من 5 ميجابايت
      setState(() {
        _profileImage = pickedFile;
      });
    } else {
      _showErrorDialog(context, 'يرجى اختيار صورة أقل من 5 ميجابايت.');
    }
  }

  void _signUpDoctor(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<SignupDoctorCubit>().signupDoctor(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            name: _nameController.text.trim(),
            specialty: _selectedSpecialty,
            address: _addressController.text.trim(),
            phone: _phoneController.text.trim(),
            profileImage: _profileImage, // تمرير الصورة
            education: _educationController.text.trim(),
            experience: _experienceController.text.trim(),
            aboutMe: _aboutMeController.text.trim(),
          );
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال بريدك الإلكتروني';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'يرجى إدخال بريد إلكتروني صالح';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال كلمة المرور الخاصة بك';
    } else if (value.length < 6) {
      return 'يجب أن تكون كلمة المرور على الأقل 6 أحرف';
    }
    return null;
  }

  String? _validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال $fieldName';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال رقم هاتفك';
    } else if (!RegExp(r'^\+?[0-9]{7,15}$').hasMatch(value)) {
      return 'يرجى إدخال رقم هاتف صالح';
    }
    return null;
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

  String _getFriendlyErrorMessage(String error) {
    if (error.contains('email-already-in-use')) {
      return 'هذا البريد الإلكتروني قيد الاستخدام بالفعل.';
    } else if (error.contains('weak-password')) {
      return 'كلمة المرور ضعيفة جداً.';
    } else if (error.contains('invalid-email')) {
      return 'عنوان البريد الإلكتروني غير صالح.';
    } else if (error.contains('network-request-failed')) {
      return 'خطأ في الشبكة. يرجى التحقق من اتصالك.';
    } else {
      return 'حدث خطأ غير معروف. يرجى المحاولة مرة أخرى.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('التسجيل كطبيب'),
        backgroundColor: Colors.deepPurple,
      ),
      body: BlocListener<SignupDoctorCubit, SignupDoctorState>(
        listener: (context, state) {
          if (state is SignupDoctorSuccess) {
            Navigator.pop(context);
          } else if (state is SignupDoctorFailure) {
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
                  'أنشئ حساب الطبيب الخاص بك',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                buildTextFieldDoctor(
                  controller: _emailController,
                  label: 'البريد الإلكتروني',
                  validator: _validateEmail,
                ),
                SizedBox(height: 16),
                buildTextFieldDoctor(
                  controller: _passwordController,
                  label: 'كلمة المرور',
                  obscureText: _obscureText,
                  validator: _validatePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
                SizedBox(height: 16),
                buildTextFieldDoctor(
                  controller: _nameController,
                  label: 'الاسم',
                  validator: (value) => _validateNotEmpty(value, 'الاسم'),
                ),
                SizedBox(height: 16),
                _buildDropdownMenu(),
                SizedBox(height: 16),
                buildTextFieldDoctor(
                  controller: _addressController,
                  label: 'العنوان (الشارع, المدينة)',
                  validator: (value) => _validateNotEmpty(value, 'العنوان'),
                ),
                SizedBox(height: 16),
                buildTextFieldDoctor(
                  controller: _phoneController,
                  label: 'رقم الهاتف',
                  validator: _validatePhone,
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 16),
                buildTextFieldDoctor(
                  controller: _educationController,
                  label: 'التعليم',
                  validator: (value) => _validateNotEmpty(value, 'التعليم'),
                ),
                SizedBox(height: 16),
                buildTextFieldDoctor(
                  controller: _experienceController,
                  label: 'الخبرة',
                  validator: (value) => _validateNotEmpty(value, 'الخبرة'),
                ),
                SizedBox(height: 16),
                buildTextFieldDoctor(
                  controller: _aboutMeController,
                  label: 'عنّي',
                  validator: (value) => _validateNotEmpty(value, 'عنّي'),
                  // ignore: deprecated_member_use
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                ),
                SizedBox(height: 16),
                _buildProfileImagePicker(),
                SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => _signUpDoctor(context),
                    child: Text(
                      'سجل كطبيب',
                      style: TextStyle(fontSize: 18, color: Colors.white),
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

  Widget _buildDropdownMenu() {
    return DropdownButtonFormField<String>(
      value: _selectedSpecialty,
      onChanged: (String? newValue) {
        setState(() {
          _selectedSpecialty = newValue!;
        });
      },
      items: <String>[
        'طب الأطفال',
        'الطب الباطني',
        'أمراض النساء',
        'أمراض القلب',
        'أمراض الجلدية',
        'أمراض الأعصاب',
        // أضف المزيد من التخصصات هنا
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'التخصص',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'يرجى اختيار تخصصك';
        }
        return null;
      },
    );
  }

  Widget _buildProfileImagePicker() {
    return Column(
      children: [
        Text(
          'صورة الملف الشخصي',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: _pickImage,
          child: CircleAvatar(
            radius: 50,
            backgroundImage: _profileImage != null
                ? FileImage(File(_profileImage!.path))
                : null,
            child: _profileImage == null
                ? Icon(FontAwesomeIcons.camera,
                    size: 50, color: Colors.grey[800])
                : null,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'اضغط لاختيار صورة',
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget buildTextFieldDoctor({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    Widget? suffixIcon,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    Widget? prefixIcon,
    int maxLines = 1,
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
        prefixIcon: prefixIcon != null
            ? IconTheme(
                data: IconThemeData(color: Colors.deepPurple),
                child: prefixIcon,
              )
            : null,
      ),
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
    );
  }
}
