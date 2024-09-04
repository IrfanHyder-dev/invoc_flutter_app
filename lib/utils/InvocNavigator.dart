import 'package:flutter/material.dart';
import 'package:invoc/v3/auth/app/auth_widget.dart';
import 'package:invoc/widgets/route_animated_widget.dart';

class InvocNavigator {
  static void goToHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, "/home");
  }

  static void goToIntro(BuildContext context) {
    Navigator.pushReplacementNamed(context, "/intro");
  }

  static void goToScanner(BuildContext context){
    Navigator.pushNamed(context, "/scanner");
  }

  static void goToPreference(BuildContext context){
    Navigator.pushNamed(context, "/preference");
  }

  static void goToUserProfile(BuildContext context){
    // Navigator.pushNamed(context, "/user");
    Navigator.push(context, CustomPageRoute(direction:AxisDirection.right, child: AuthWidget()));
    // Navigator.pushNamed(context, "/user");
  }

}