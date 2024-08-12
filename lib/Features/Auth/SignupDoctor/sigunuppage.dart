import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hamo_pharmacy/Features/Auth/SignupDoctor/signupcubit.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _selectedSpecialty = 'Pediatrics'; // التخصص الافتراضي
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
      _showErrorDialog(context, 'Please select an image less than 5MB.');
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
          );
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your Email';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please enter a valid Email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your Password';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter your $fieldName';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your Phone Number';
    } else if (!RegExp(r'^\+?[0-9]{7,15}$').hasMatch(value)) {
      return 'Please enter a valid Phone Number';
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
              Text('Error'),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String _getFriendlyErrorMessage(String error) {
    if (error.contains('email-already-in-use')) {
      return 'This email is already in use.';
    } else if (error.contains('weak-password')) {
      return 'The password is too weak.';
    } else if (error.contains('invalid-email')) {
      return 'The email address is not valid.';
    } else if (error.contains('network-request-failed')) {
      return 'Network error. Please check your connection.';
    } else {
      return 'An unknown error occurred. Please try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up as Doctor'),
        backgroundColor: Colors.redAccent,
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
                  'Create your Doctor Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  validator: _validateEmail,
                ),
                SizedBox(height: 16),
                buildTextField(
                  controller: _passwordController,
                  label: 'Password',
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
                buildTextField(
                  controller: _nameController,
                  label: 'Name',
                  validator: (value) => _validateNotEmpty(value, 'Name'),
                ),
                SizedBox(height: 16),
                _buildDropdownMenu(),
                SizedBox(height: 16),
                buildTextField(
                  controller: _addressController,
                  label: 'Address',
                  validator: (value) => _validateNotEmpty(value, 'Address'),
                ),
                SizedBox(height: 16),
                buildTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  validator: _validatePhone,
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 16),
                _buildProfileImagePicker(),
                SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => _signUpDoctor(context),
                    child: Text(
                      'Sign Up as Doctor',
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

  Widget buildTextField({
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

  Widget _buildDropdownMenu() {
    return DropdownButtonFormField<String>(
      value: _selectedSpecialty,
      onChanged: (String? newValue) {
        setState(() {
          _selectedSpecialty = newValue!;
        });
      },
      items: <String>[
        'Pediatrics',
        'Internal Medicine',
        'Gynecology',
        'Cardiology',
        'Dermatology',
        'Neurology',
        // أضف المزيد من التخصصات هنا
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Specialty',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select your Specialty';
        }
        return null;
      },
    );
  }

  Widget _buildProfileImagePicker() {
    return Column(
      children: [
        Text(
          'Profile Image',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: _pickImage,
          child: CircleAvatar(
            radius: 50,
            backgroundImage: _profileImage != null
                ? FileImage(File(_profileImage!.path))
                : AssetImage('assets/images/default_profile.png')
                    as ImageProvider,
            child: _profileImage == null
                ? Icon(Icons.camera_alt, size: 50, color: Colors.grey[800])
                : null,
          ),
        ),
        if (_profileImage == null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Tap to select an image',
              style: TextStyle(color: Colors.grey),
            ),
          ),
      ],
    );
  }
}
