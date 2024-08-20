import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _educationController;
  late TextEditingController _experienceController;
  late TextEditingController _specialtyController;
  late String _imageUrl;
  bool _isEditing = false;
  bool _isDoctor = false;
  DocumentSnapshot? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final doctorDoc =
          await _firestore.collection('doctors').doc(user.uid).get();
      if (doctorDoc.exists) {
        setState(() {
          _isDoctor = true;
          _userData = doctorDoc;
          _nameController =
              TextEditingController(text: _userData?.get('name') ?? '');
          _emailController = TextEditingController(text: user.email ?? '');
          _phoneController =
              TextEditingController(text: _userData?.get('phone') ?? '');
          _educationController =
              TextEditingController(text: _userData?.get('education') ?? '');
          _experienceController =
              TextEditingController(text: _userData?.get('experience') ?? '');
          _specialtyController =
              TextEditingController(text: _userData?.get('specialty') ?? '');
          _imageUrl = _userData?.get('imageUrl') ??
              'https://example.com/default_profile.png';
        });
      } else {
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          setState(() {
            _isDoctor = false;
            _userData = userDoc;
            _nameController =
                TextEditingController(text: _userData?.get('name') ?? '');
            _emailController = TextEditingController(text: user.email ?? '');
            _phoneController =
                TextEditingController(); // Leave it empty for users
            _educationController = TextEditingController();
            _experienceController = TextEditingController();
            _specialtyController = TextEditingController();
            _imageUrl = _userData?.get('imageUrl') ??
                'https://example.com/default_profile.png';
          });
        }
      }
    } catch (e) {
      print("Error loading user data: $e");
    }
  }

  Future<void> _updateUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection(_isDoctor ? 'doctors' : 'users')
        .doc(user.uid)
        .update({
      'name': _nameController.text,
      'phone': _isDoctor ? _phoneController.text : null,
      'education': _isDoctor ? _educationController.text : null,
      'experience': _isDoctor ? _experienceController.text : null,
      'specialty': _isDoctor ? _specialtyController.text : null,
      'imageUrl': _imageUrl,
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('تم تحديث الملف الشخصي بنجاح')));
    setState(() {
      _isEditing = false;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      try {
        final storageRef =
            _storage.ref().child('profile_images/${_auth.currentUser!.uid}');
        await storageRef.putFile(imageFile);
        final downloadUrl = await storageRef.getDownloadURL();

        setState(() {
          _imageUrl = downloadUrl;
        });

        await _updateUserProfile(); // Update Firestore with new image URL
      } catch (e) {
        print("Error uploading image: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_userData == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('ملفي الشخصي'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: _isEditing ? _pickImage : null,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(_imageUrl),
                    child: _isEditing
                        ? Align(
                            alignment: Alignment.bottomRight,
                            child:
                                Icon(Icons.edit, color: Colors.white, size: 24),
                          )
                        : null,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            _buildEditableField('اسم المستخدم', _nameController),
            SizedBox(height: 16),
            _buildReadOnlyField('البريد الإلكتروني', _emailController),
            if (_isDoctor) ...[
              SizedBox(height: 16),
              _buildEditableField('رقم الهاتف', _phoneController),
              SizedBox(height: 16),
              _buildEditableField('التعليم', _educationController),
              SizedBox(height: 16),
              _buildEditableField('الخبرة', _experienceController),
              SizedBox(height: 16),
              _buildEditableField('التخصص', _specialtyController),
            ],
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isEditing
                  ? _updateUserProfile
                  : () {
                      setState(() {
                        _isEditing = true;
                      });
                    },
              child: Text(
                _isEditing ? 'حفظ التعديلات' : 'تعديل الملف الشخصي',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      enabled: _isEditing,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: _isEditing ? Colors.white : Colors.grey[200],
      ),
    );
  }

  Widget _buildReadOnlyField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }
}
