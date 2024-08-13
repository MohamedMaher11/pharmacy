import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hamo_pharmacy/gen/assets.gen.dart';
import 'package:image_picker/image_picker.dart';

class SignupCubit extends Cubit<SignupState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  SignupCubit() : super(SignupInitial());

  void signupWithEmail({
    required String email,
    required String password,
    required String name,
    XFile? profileImage,
  }) async {
    try {
      emit(SignupLoading());

      // إنشاء حساب جديد في Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // الحصول على UID الخاص بالمستخدم الجديد
      String uid = userCredential.user?.uid ?? '';

      // تحميل الصورة إلى Firebase Storage (إذا تم تحديد صورة)
      String? imageUrl;
      if (profileImage != null) {
        imageUrl = await _uploadProfileImage(uid, profileImage);
      } else {
        // استخدم صورة افتراضية إذا لم يتم اختيار صورة
        imageUrl = Assets.user.path;
      }

      // حفظ بيانات المستخدم في Firestore باستخدام UID
      await _saveUserData(uid, email, name, imageUrl);

      emit(SignupSuccess());
    } catch (e) {
      emit(SignupFailure(e.toString()));
    }
  }

  Future<String> _uploadProfileImage(String uid, XFile image) async {
    try {
      Reference storageRef =
          FirebaseStorage.instance.ref().child('profile_images/$uid.jpg');
      UploadTask uploadTask = storageRef.putFile(File(image.path));
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Failed to upload profile image');
    }
  }

  Future<void> _saveUserData(
    String uid,
    String email,
    String name,
    String? imageUrl,
  ) async {
    final firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection('users').doc(uid).set({
        'email': email,
        'name': name,
        'uid': uid,
        'imageUrl': imageUrl, // حفظ رابط الصورة في Firestore
      });
    } catch (e) {
      print('Error saving user data: $e');
      throw Exception('Failed to save user data');
    }
  }

  void signInWithEmail(String email, String password) async {
    emit(SignupLoading());
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      emit(SignupSuccess());
    } catch (e) {
      emit(SignupFailure(e.toString()));
    }
  }
}

abstract class SignupState {}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {}

class SignupFailure extends SignupState {
  final String error;

  SignupFailure(this.error);
}

class SignupCodeSent extends SignupState {}
