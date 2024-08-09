import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class NameInputScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final String email;

  NameInputScreen({required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Your Name'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Almost done! Enter your name',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            SizedBox(height: 40),
            _buildTextField(_nameController, 'Name'),
            SizedBox(height: 32),
            SizedBox(
              width: 370,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  await _saveUserData();
                  Navigator.pushNamed(context, '/home');
                },
                child: Text(
                  'Finish',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Future<void> _saveUserData() async {
    final firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection('users').add({
        'email': email,
        'name': _nameController.text,
      });
    } catch (e) {
      // Handle error
      print('Error saving user data: $e');
    }
  }
}
