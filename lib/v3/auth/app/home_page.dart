import 'dart:async';

import 'package:get/get.dart';
import 'package:invoc/src/language/language_keys.dart';
import 'package:invoc/utils/InvocNavigator.dart';
import 'package:invoc/v3/auth/app/sign_in/social_sign_in_button.dart';
import 'package:invoc/v3/auth/common_widgets/avatar.dart';
import 'package:invoc/v3/auth/common_widgets/platform_exception_alert_dialog.dart';
import 'package:invoc/v3/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:invoc/v3/auth/services/firebase_auth_service.dart';
import 'package:invoc/v3/views/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserFromFirebase>(builder: (context, user, _) {
      return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/fruit_falling.png'),
                fit: BoxFit.fitHeight)),
        child: Scaffold(
          appBar: CustomAppBar(true, false),
          body: _buildUserInfo(user, context),
        ),
      );
    });
  }

  Widget _buildUserInfo(UserFromFirebase user, BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: height * 0.17,
            ),
            Center(
              child: Avatar(
                photoUrl: (user.photoUrl != null) ? user.photoUrl! : null,
                radius: 80,
                borderColor: Colors.white10,
                borderWidth: 1.0,
              ),
            ),
            SizedBox(height: 8),
            if (user.displayName != null && user.displayName!.isNotEmpty)
              Text(
                user.displayName!,
                style: TextStyle(color: Colors.black),
              ),
            SizedBox(height: 8),
            if (user.email != null)
              Text(
                user.email!,
                style: TextStyle(color: Colors.black),
              ),
            SizedBox(height: 16),
            SignInButton(
              text: 'Preference',
              onPressed: () => InvocNavigator.goToPreference(context),
              textColor: Colors.white,
              color: Color(0xFF8FE17F),
            ),
            // SizedBox(height: MediaQuery.of(context).size.height * 0.35,),
            SizedBox(height: height * 0.1,),

            Center(
              child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => ConfirmationDialog(user: user),
                    );
                  },
                  child: Text(
                    deleteAccountKey.tr,
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  )),
            ),
          ],
        ));
  }
}

class ConfirmationDialog extends StatefulWidget {
  final UserFromFirebase user;

  ConfirmationDialog({
    required this.user,
    super.key,
  });

  @override
  State<ConfirmationDialog> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  bool showProgress = false;

  @override
  Widget build(BuildContext context) {
    return (showProgress)
        ? Center(child: CircularProgressIndicator())
        : AlertDialog(
            title:  Text(deleteAccountDialogHeadingKey.tr),
            content:
                 Text(confirmationStringKey.tr),
            actions: [
              TextButton(
                child:  Text(cancelKey.tr),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  deleteKey.tr,
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () async {
                  setState(() {
                    showProgress = true;
                  });

                  Future.delayed(
                    Duration(seconds: 3),
                    () {
                      Navigator.of(context).pop();
                      _firebaseAuthService.deleteUserAccount();
                    },
                  );
                },
              ),
            ],
          );
  }
}
