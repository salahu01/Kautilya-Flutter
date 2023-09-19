import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class AuthCtrl {
  //* This variable for store global instance of this.
  static late final AuthCtrl? _instance;

  //* This variable for store firebase instance
  late final FirebaseAuth _auth;

  //* This constructor for create instance initial time
  factory AuthCtrl._create() {
    _instance ??= AuthCtrl._();
    return _instance!;
  }

  //* provide instance this.
  AuthCtrl._() {
    _auth = FirebaseAuth.instance;
    _currentUser.sink.add(_auth.currentUser);
  }

  //* for geting instace globally
  static AuthCtrl get instance => AuthCtrl._create();

  final _isLoading = BehaviorSubject<bool>.seeded(false);

  final _currentUser = BehaviorSubject<User?>.seeded(null);

  ValueStream<User?> get user => _currentUser.stream;

  String? verificationId;
  void generateOtp(String phone) async {
    _isLoading.sink.add(true);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) {
        verificationId = credential.verificationId;
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'network-request-failed') {
          return;
        }
        if (e.code == 'invalid-phone-number') {
          throw 'The provided phone number is not valid.';
        }
        throw e.message ?? 'something went wrong ! please try again later ';
      },
      codeSent: (String id, int? resendToken) {
        verificationId = id;
      },
      codeAutoRetrievalTimeout: (String id) {
        verificationId = id;
      },
    );
    _isLoading.sink.add(false);
  }

  void verifyOtp(String otp) async {
    try {
      final userCredential = await _auth.signInWithCredential(PhoneAuthProvider.credential(verificationId: verificationId ?? '', smsCode: otp));
      _currentUser.sink.add(userCredential.user);
    } catch (e) {}
  }
}
