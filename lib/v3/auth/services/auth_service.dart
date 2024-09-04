import 'dart:async';

import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:meta/meta.dart';

@immutable
class UserFromFirebase {
  const UserFromFirebase({
    required this.uid,
    this.email,
    this.photoUrl,
    this.displayName,
    this.isAnonymous = false,
  });

  final String uid;
  final String? email;
  final String? photoUrl;
  final String? displayName;
  final bool isAnonymous;
}

abstract class AuthService {
  Future<UserFromFirebase> currentUser();

  Future<UserFromFirebase> signInAnonymously();

  Future<UserFromFirebase> signInWithEmailAndPassword(
      String email, String password);

  Future<UserFromFirebase> createUserWithEmailAndPassword(
      String email, String password);

  Future<void> sendPasswordResetEmail(String email);

  Future<UserFromFirebase> signInWithEmailAndLink({String email, String link});

  Future<bool> isSignInWithEmailLink(String link);

  Future<void> sendSignInWithEmailLink({
    @required String email,
    @required String url,
    @required bool handleCodeInApp,
    @required String iOSBundleID,
    @required String androidPackageName,
    @required bool androidInstallIfNotAvailable,
    @required String androidMinimumVersion,
  });

  Future<UserFromFirebase> signInWithGoogle();

  Future<UserFromFirebase> signInWithFacebook();

  Future<UserFromFirebase> signInWithApple();

  Future<void> signOut();

  Stream<UserFromFirebase> get onAuthStateChanged;

  void dispose();
}
