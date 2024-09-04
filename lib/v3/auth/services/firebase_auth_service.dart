import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:invoc/v3/auth/services/auth_service.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final pref = SharedPreferences.getInstance();

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  UserFromFirebase? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    }
    if (user.email != null) {
      print('Firebase auth services user data ${user.email}   ${user}');
      SharedPreferences.getInstance().then((value) {
        value.setBool('login', true);
        value.setString('userId', user.uid);
        value.setString('email', user.email!);
        value.setBool('isAnonymous', user.isAnonymous);
      });
    }

    FirebaseAnalytics.instance.setUserId(id: user.uid);

    return UserFromFirebase(
        uid: user.uid,
        email: (user.email != null) ? user.email! : null,
        displayName: (user.displayName != null) ? user.displayName! : null,
        photoUrl: (user.photoURL != null) ? user.photoURL! : null,
        isAnonymous: user.isAnonymous);
  }

  @override
  Stream<UserFromFirebase> get onAuthStateChanged {
    // return _firebaseAuth.authStateChanges().map(_userFromFirebase!);
    return _firebaseAuth
        .authStateChanges()
        .map((user) => _userFromFirebase(user)!);
  }

  @override
  Future<UserFromFirebase> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    print('signin anonymously ${authResult.user!}');
    return _userFromFirebase(authResult.user!)!;
  }

  @override
  Future<UserFromFirebase> signInWithEmailAndPassword(
      String email, String password) async {
    //if user is login as Anonymous user
    // await signOut();
    var authResult;
    try{
      authResult = await _firebaseAuth
          .signInWithCredential(EmailAuthProvider.credential(
        email: email,
        password: password,
      ));

    }on FirebaseAuthException catch(e){
      throw PlatformException(
              code: 'firebase_auth/email-already-in-use',
              message: '${e.message}');
    }
    return _userFromFirebase(authResult.user!)!;
  }

  @override
  Future<UserFromFirebase> createUserWithEmailAndPassword(
      String email, String password) async {
    //if user is login as Anonymous user
    // await signOut();
    print('create user with email $email  $password');
    var authResult ;
    try{
      authResult = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
    }on FirebaseAuthException catch(e){
      throw PlatformException(
          code: 'firebase_auth/email-already-in-use',
          message: '${e.message}');
    }
    return _userFromFirebase(authResult.user!)!;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<UserFromFirebase> signInWithEmailAndLink(
      {String? email, String? link}) async {
    final authResult = await _firebaseAuth.signInWithEmailLink(
        email: email!, emailLink: link!);
    return _userFromFirebase(authResult.user!)!;
  }

  @override
  Future<bool> isSignInWithEmailLink(String link) async {
    return await _firebaseAuth.isSignInWithEmailLink(link);
  }

  @override
  Future<void> sendSignInWithEmailLink({
    String? email,
    String? url,
    bool? handleCodeInApp,
    String? iOSBundleID,
    String? androidPackageName,
    bool? androidInstallIfNotAvailable,
    String? androidMinimumVersion,
  }) async {
    return await _firebaseAuth.sendSignInLinkToEmail(
      email: email!,
      actionCodeSettings: ActionCodeSettings(
        url: url!,
        handleCodeInApp: handleCodeInApp!,
        iOSBundleId: iOSBundleID,
        androidPackageName: androidPackageName,
        androidInstallApp: androidInstallIfNotAvailable!,
        androidMinimumVersion: androidMinimumVersion,
      ),
    );
  }

  @override
  Future<UserFromFirebase> signInWithGoogle() async {
    //if user is login as Anonymous user
    // await signOut();
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final authResult = await _firebaseAuth
            .signInWithCredential(GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
        print('google signin ${authResult.user!}');
        return _userFromFirebase(authResult.user!)!;
      } else {
        throw PlatformException(
            code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
            message: 'Missing Google Auth Token');
      }
    } else {
      throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    }
  }

  // @override
  // Future<UserFromFirebase>? signInWithFacebook() async {
  //   //if user is login as Anonymous user
  //   await signOut();
  //
  //   final FacebookLogin facebookLogin = FacebookLogin();
  //   // https://github.com/roughike/flutter_facebook_login/issues/210
  //   // facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
  //   // final FacebookLoginResult result =
  //   //     await facebookLogin.logIn(<String>['public_profile']);
  //   // if (result.accessToken != null) {
  //   //   final authResult = await _firebaseAuth.signInWithCredential(
  //   //       FacebookAuthProvider.credential(result.accessToken.token));
  //   //   return _userFromFirebase(authResult.user);
  //   // } else {
  //   //   throw PlatformException(
  //   //       code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
  //   // }
  // }

/*  @override
  Future<UserFromFirebase> signInWithApple() async {
    List scopes = [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName
    ];
    var appleProvider = AppleAuthProvider();
    scopes.forEach((element) {
      appleProvider.addScope(element.toString());
    });

    await _firebaseAuth.signInWithProvider(appleProvider).then((value) async {
      var firebaseUser = value.user!;
      var displayName = '${firebaseUser.displayName}';
      print("User From Apple $displayName ${firebaseUser.email}");
      await firebaseUser.updateDisplayName(displayName);
      return _userFromFirebase(firebaseUser);
    }).onError((error, stackTrace) {
      throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    });
    throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');

  }*/

  @override
  Future<UserFromFirebase> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);
    try {
      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      print("Apple Credentials: $appleCredential");

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      final authResult =
          await _firebaseAuth.signInWithCredential(oauthCredential);

      final displayName =
          '${appleCredential.givenName} ${appleCredential.familyName}';
      await authResult.user?.updateDisplayName(displayName);

      final firebaseUser = authResult.user;
      print("Firebase DisplayName ${firebaseUser?.displayName}");
      return _userFromFirebase(firebaseUser)!;
    } catch (exception) {
      print(exception);
    }
    throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
  }

  @override
  Future<UserFromFirebase> currentUser() async {
    final User? user = _firebaseAuth.currentUser;
    return _userFromFirebase(user)!;
  }

  @override
  Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    //  final FacebookLogin facebookLogin = FacebookLogin();
    //  await facebookLogin.logOut();
    SharedPreferences.getInstance().then((value) {
      value.setBool('login', false);
      value.setBool('isAnonymous', false);
    });
    return _firebaseAuth.signOut();
  }

  Future<void> deleteUserAccount() async {
    try {
      await signOut();
      // await FirebaseAuth.instance.currentUser!.delete();
      await _firebaseAuth.currentUser!.delete().whenComplete(() {
        Future.delayed(Duration(seconds: 0),() => print('account deleted'),);
      });

    } on FirebaseAuthException catch (e) {
      print('error in firebase auth class ${e.code}');
      if (e.code == "requires-recent-login") {
        await _reauthenticateAndDelete();
      } else {
        // Handle other Firebase exceptions
      }
    } catch (e) {
      print('catch block of delete account in firebase auth class $e');
      // Handle general exception
    }
  }

  Future<void> _reauthenticateAndDelete() async {
    try {
      final providerData = _firebaseAuth.currentUser?.providerData.first;
      print('-----------  ${AppleAuthProvider().providerId == providerData!.providerId}');
      print('-----------  ${GoogleAuthProvider().providerId == providerData.providerId}');
      print('-----------  ${providerData!.providerId}');
      if (AppleAuthProvider().providerId == providerData!.providerId) {
        await _firebaseAuth.currentUser!
            .reauthenticateWithProvider(AppleAuthProvider());
      } else if (GoogleAuthProvider().providerId == providerData.providerId) {
        await _firebaseAuth.currentUser!
            .reauthenticateWithProvider(GoogleAuthProvider());
      }

      await _firebaseAuth.currentUser?.delete();
    } catch (e) {
      // Handle exceptions
    }
  }

  @override
  void dispose() {}

  @override
  Future<UserFromFirebase> signInWithFacebook() {
    // TODO: implement signInWithFacebook
    throw UnimplementedError();
  }
}
