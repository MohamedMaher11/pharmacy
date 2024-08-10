import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupCubit extends Cubit<SignupState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;

  SignupCubit() : super(SignupInitial());

  void signupWithEmail(String email, String password, String name) async {
    try {
      emit(SignupLoading());
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _saveUserData(email, name);
      emit(SignupSuccess());
    } catch (e) {
      emit(SignupFailure(e.toString()));
    }
  }

  void signupWithPhone(String phoneNumber) async {
    emit(SignupLoading());
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          emit(SignupSuccess());
        },
        verificationFailed: (FirebaseAuthException e) {
          emit(SignupFailure(e.message ?? 'Verification failed'));
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          emit(SignupCodeSent());
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      emit(SignupFailure(e.toString()));
    }
  }

  void verifyPhoneCode(String smsCode) async {
    emit(SignupLoading());
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );
      await _auth.signInWithCredential(credential);
      emit(SignupSuccess());
    } catch (e) {
      emit(SignupFailure(e.toString()));
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

Future<void> _saveUserData(String email, String name) async {
  final firestore = FirebaseFirestore.instance;
  try {
    await firestore.collection('users').add({
      'email': email,
      'name': name,
    });
  } catch (e) {
    // Handle error
    print('Error saving user data: $e');
  }
}
