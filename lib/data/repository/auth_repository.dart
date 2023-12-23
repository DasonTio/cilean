import 'package:cilean/data/models/user_model.dart';
import 'package:cilean/data/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cilean/data/resource/firebase_response.dart';

class AuthRepository {
  AuthRepository();

  final UserRepository _userRepository = UserRepository();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<FirebaseResponse<UserCredential>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential credential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return FirebaseResponse(
        data: credential,
        message: "Login Success",
      );
    } catch (e) {
      return const FirebaseResponse(
        message: "Login Error",
        status: 401,
      );
    }
  }

  Future<FirebaseResponse<UserCredential>> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential credential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      credential.user?.updateDisplayName(name);
      _userRepository.create(UserModel(
        email: email,
        name: name,
        role: 'user',
      ));

      return FirebaseResponse(
        data: credential,
        message: "Sign Up Success",
      );
    } catch (e) {
      return const FirebaseResponse(
        message: "Login Failed",
        status: 401,
      );
    }
  }

  Future<FirebaseResponse<UserCredential>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final user = await FirebaseAuth.instance.signInWithCredential(credential);
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();

      return FirebaseResponse(
        data: user,
        message: "Login Success",
      );
    } catch (e) {
      return const FirebaseResponse(
        message: "Login Failed",
        status: 401,
      );
    }
  }

  Future<FirebaseResponse<UserCredential>> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      final credential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);
      return FirebaseResponse(
          data: await FirebaseAuth.instance.signInWithCredential(credential),
          message: "Login Success");
    } catch (e) {
      return const FirebaseResponse(
        message: "Login Failed",
        status: 401,
      );
    }
  }
}
