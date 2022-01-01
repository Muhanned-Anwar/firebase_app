import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:vp7_firebase_app/utils/helpers.dart';

typedef UserAuthStatus = void Function({required bool loggedIn});

class FbAuthController with Helpers {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<bool> signIn(
      {required BuildContext context,
      required String email,
      required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        if (userCredential.user!.emailVerified) {
          return true;
        } else {
          await signOut();
          showSnackBar(
              context: context,
              message: 'Verify email to login into the app!',
              error: true);
          return false;
        }
      }
      return false;
    } on FirebaseAuthException catch (e) {
      controlException(context, e);
    } catch (e) {
      //
    }
    return false;
  }

  Future<bool> createAccount(
      {required BuildContext context,
      required String email,
      required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      userCredential.user?.sendEmailVerification();
      return true;
    } on FirebaseAuthException catch (e) {
      controlException(context, e);
    } catch (e) {
      //
    }
    return false;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  bool loggedIn() => _firebaseAuth.currentUser != null;

  StreamSubscription<User?> checkUserStatus(UserAuthStatus userAuthStatus){
    return _firebaseAuth.authStateChanges().listen((event) {
      userAuthStatus(loggedIn: event != null);
    });
  }

  void controlException(BuildContext context, FirebaseAuthException exception) {
    showSnackBar(context: context, message: exception.message ?? 'Error!');
    switch (exception.code) {
      case 'invalid-email':
        break;

      case 'user-disabled':
        break;

      case 'user-not-found':
        break;

      case 'wrong-password':
        break;
    }
  }
}
