import 'dart:async';

import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:invoc/v3/auth/services/auth_service.dart';
import 'package:invoc/v3/auth/services/firebase_auth_service.dart';
import 'package:invoc/v3/auth/services/mock_auth_service.dart';
import 'package:flutter/foundation.dart';

enum AuthServiceType { firebase, mock }

class AuthServiceAdapter implements AuthService {
  AuthServiceAdapter({required AuthServiceType initialAuthServiceType})
      : authServiceTypeNotifier =
            ValueNotifier<AuthServiceType>(initialAuthServiceType) {
    _setup();
  }
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  final MockAuthService _mockAuthService = MockAuthService();

  final ValueNotifier<AuthServiceType> authServiceTypeNotifier;
  AuthServiceType get authServiceType => authServiceTypeNotifier.value;
  AuthService get authService => authServiceType == AuthServiceType.firebase
      ? _firebaseAuthService
      : _mockAuthService;

  StreamSubscription<UserFromFirebase>? _firebaseAuthSubscription;
  StreamSubscription<UserFromFirebase>? _mockAuthSubscription;

  void _setup() {
    _firebaseAuthSubscription =
        _firebaseAuthService.onAuthStateChanged.listen((UserFromFirebase user) {
      if (authServiceType == AuthServiceType.firebase) {
        _onAuthStateChangedController.add(user);
      }
    }, onError: (dynamic error) {
      if (authServiceType == AuthServiceType.firebase) {
        _onAuthStateChangedController.addError(error);
      }
    });
    _mockAuthSubscription =
        _mockAuthService.onAuthStateChanged.listen((UserFromFirebase user) {
      if (authServiceType == AuthServiceType.mock) {
        _onAuthStateChangedController.add(user);
      }
    }, onError: (dynamic error) {
      if (authServiceType == AuthServiceType.mock) {
        _onAuthStateChangedController.addError(error);
      }
    });
  }

  @override
  void dispose() {
    _firebaseAuthSubscription?.cancel();
    _mockAuthSubscription?.cancel();
    _onAuthStateChangedController?.close();
    _mockAuthService.dispose();
    authServiceTypeNotifier.dispose();
  }

  final StreamController<UserFromFirebase> _onAuthStateChangedController =
      StreamController<UserFromFirebase>.broadcast();
  @override
  Stream<UserFromFirebase> get onAuthStateChanged => _onAuthStateChangedController.stream;

  @override
  Future<UserFromFirebase> currentUser() => authService.currentUser();

  @override
  Future<UserFromFirebase> signInAnonymously() => authService.signInAnonymously();

  @override
  Future<UserFromFirebase> createUserWithEmailAndPassword(String email, String password) =>
      authService.createUserWithEmailAndPassword(email, password);

  @override
  Future<UserFromFirebase> signInWithEmailAndPassword(String email, String password) =>
      authService.signInWithEmailAndPassword(email, password);

  @override
  Future<void> sendPasswordResetEmail(String email) =>
      authService.sendPasswordResetEmail(email);

  @override
  Future<UserFromFirebase> signInWithEmailAndLink({String? email, String? link}) =>
      authService.signInWithEmailAndLink(email: email!, link: link!);

  @override
  Future<bool> isSignInWithEmailLink(String link) =>
      authService.isSignInWithEmailLink(link);

  @override
  Future<void> sendSignInWithEmailLink({
     String? email,
     String? url,
     bool? handleCodeInApp,
     String? iOSBundleID,
     String? androidPackageName,
     bool? androidInstallIfNotAvailable,
     String? androidMinimumVersion,
  }) =>
      authService.sendSignInWithEmailLink(
        email: email!,
        url: url!,
        handleCodeInApp: handleCodeInApp!,
        iOSBundleID: iOSBundleID!,
        androidPackageName: androidPackageName!,
        androidInstallIfNotAvailable: androidInstallIfNotAvailable!,
        androidMinimumVersion: androidMinimumVersion!,
      );

  @override
  Future<UserFromFirebase> signInWithFacebook() => authService.signInWithFacebook();

  @override
  Future<UserFromFirebase> signInWithGoogle() => authService.signInWithGoogle();

  @override
  Future<UserFromFirebase> signInWithApple() =>
      authService.signInWithApple( );

  @override
  Future<void> signOut() => authService.signOut();


}
