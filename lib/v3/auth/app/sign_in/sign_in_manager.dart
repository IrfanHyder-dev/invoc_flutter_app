import 'dart:async';

import 'package:invoc/v3/auth/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

class SignInManager {
  SignInManager({required this.auth, required this.isLoading});

  final AuthService auth;
  final ValueNotifier<bool> isLoading;

  Future<UserFromFirebase> _signIn(
      Future<UserFromFirebase> Function() signInMethod) async {
    try {
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  Future<UserFromFirebase> signInAnonymously() async {
    return await _signIn(auth.signInAnonymously);
  }

  Future<UserFromFirebase> signInWithGoogle() async {
    return await _signIn(auth.signInWithGoogle);
  }

  Future<UserFromFirebase> signInWithFacebook() async {
    return await _signIn(auth.signInWithFacebook);
  }

  Future<UserFromFirebase> signInWithApple() async {
    return await _signIn(auth.signInWithApple);
  }
}
