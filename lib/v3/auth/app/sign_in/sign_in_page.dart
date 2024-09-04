import 'dart:io' show Platform;

import 'package:sign_in_with_apple/sign_in_with_apple.dart' as apple;
import 'package:get/get.dart';
import 'package:invoc/src/language/language_keys.dart';
import 'package:invoc/v3/auth/app/sign_in/email_password/email_password_sign_in_page.dart';
import 'package:invoc/v3/auth/app/sign_in/sign_in_manager.dart';
import 'package:invoc/v3/auth/app/sign_in/social_sign_in_button.dart';
import 'package:invoc/v3/auth/common_widgets/platform_exception_alert_dialog.dart';
import 'package:invoc/v3/auth/constants/keys.dart';
import 'package:invoc/v3/auth/services/apple_sign_in_available.dart';
import 'package:invoc/v3/auth/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:invoc/v3/views/custom_app_bar.dart';
import 'package:provider/provider.dart';

class SignInPageBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of<AuthService>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, ValueNotifier<bool> isLoading, __) =>
            Provider<SignInManager>(
          create: (_) => SignInManager(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManager>(
            builder: (_, SignInManager manager, __) => SignInPage._(
              isLoading: isLoading.value,
              manager: manager,
              title: 'Firebase Auth Demo',
            ),
          ),
        ),
      ),
    );
  }
}

class SignInPage extends StatelessWidget {
  const SignInPage._({ required this.isLoading, this.manager, this.title}) ;
  final SignInManager? manager;
  final String? title;
  final bool isLoading;

  static const Key googleButtonKey = Key('google');
  static const Key facebookButtonKey = Key('facebook');
  static const Key emailPasswordButtonKey = Key('email-password');
  static const Key emailLinkButtonKey = Key('email-link');
  static const Key anonymousButtonKey = Key(Keys.anonymous);

  Future<void> _showSignInError(
      BuildContext context, PlatformException exception) async {
    await PlatformExceptionAlertDialog(
      title: signInFailedKey.tr,
      exception: exception,
    ).show(context);
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager!.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      await manager!.signInWithFacebook();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  Future<void> signInWithApple(BuildContext context) async {
    try {
      await manager!.signInWithApple();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    final navigator = Navigator.of(context);
    await EmailPasswordSignInPage.show(
      context,
      onSignedIn: navigator.pop,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(true, false),
      backgroundColor: Colors.white,
      body: _buildSignIn(context),
    );
  }

  Widget _buildHeader() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      signInKey.tr,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildSignIn(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final appleSignInAvailable = Provider.of<AppleSignInAvailable>(context);
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/fruit_falling.png'),
              fit: BoxFit.fitHeight)),
      child: Align(
        alignment: FractionalOffset.bottomCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 50.0,
              child: _buildHeader(),
            ),
            SizedBox(height: size.height / 3),
            if (appleSignInAvailable.isAvailable && Platform.isIOS)...[
              apple.SignInWithAppleButton(
                // key: apple.ButtonType.signIn,
                // style: apple.ButtonStyle.black,
                onPressed: ()=> isLoading ? null :  signInWithApple(context),
                // onPressed: isLoading ? null : ()async => signInWithApple(context),
              ),
              SizedBox(height: 8),
            ],
            if(Platform.isAndroid)
            Material(
              child: SocialSignInButton(
                // key: googleButtonKey,
                assetName: 'assets/go-logo.png',
                text: signInWithGoogleKey.tr,
                onPressed: isLoading ? null : () => _signInWithGoogle(context),
                color: Colors.white,
                textColor: Colors.grey,
              ),
            ),
            // SizedBox(height: 8),
            // SocialSignInButton(
            //   // key: facebookButtonKey,
            //   assetName: 'assets/fb-logo.png',
            //   text: signInWithFacebookKey.tr,
            //   textColor: Colors.white,
            //   onPressed: isLoading ? null : () => _signInWithFacebook(context),
            //   color: Color(0xFF334D92),
            // ),
            SizedBox(height: 8),
            SignInButton(
              // key: emailPasswordButtonKey,
              text: signInWithEmailPasswordKey.tr,
              onPressed: (){
                _signInWithEmailAndPassword(context);
              },
              textColor: Colors.white,
              color: Color(0xFF8FE17F),
            ),
          ],
        ),
      ),
    );
  }
}
