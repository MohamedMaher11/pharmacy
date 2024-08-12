import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hamo_pharmacy/gen/assets.gen.dart';
import 'package:image_picker/image_picker.dart';

class SignupDoctorCubit extends Cubit<SignupDoctorState> {
  SignupDoctorCubit() : super(SignupDoctorInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signupDoctor({
    required String email,
    required String password,
    required String name,
    required String specialty,
    required String address,
    required String phone,
    XFile? profileImage,
  }) async {
    try {
      emit(SignupDoctorLoading());

      // إنشاء الحساب
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // رفع الصورة الشخصية إذا كانت موجودة
      String? imageUrl;
      if (profileImage != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_images/${userCredential.user!.uid}');
        await storageRef.putFile(File(profileImage.path));
        imageUrl = await storageRef.getDownloadURL();
      } else {
        imageUrl = Assets.user.path; // استخدم URL افتراضي للصورة
      }

      // تخزين بيانات الطبيب في Firestore
      await _firestore.collection('doctors').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'specialty': specialty,
        'address': address,
        'phone': phone,
        'imageUrl': imageUrl,
        'doctorId': userCredential.user!.uid,
      });

      emit(SignupDoctorSuccess());
    } catch (e) {
      emit(SignupDoctorFailure(e.toString()));
    }
  }
}

abstract class SignupDoctorState {}

class SignupDoctorInitial extends SignupDoctorState {}

class SignupDoctorLoading extends SignupDoctorState {}

class SignupDoctorSuccess extends SignupDoctorState {}

class SignupDoctorFailure extends SignupDoctorState {
  final String error;
  SignupDoctorFailure(this.error);
}
