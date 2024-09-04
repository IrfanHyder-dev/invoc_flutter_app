import 'package:invoc/v3/auth/app/home_page.dart';
import 'package:invoc/v3/auth/app/sign_in/sign_in_page.dart';
import 'package:invoc/v3/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Builds the signed-in or non signed-in UI, depending on the user snapshot.
/// This widget should be below the [MaterialApp].
/// An [AuthWidgetBuilder] ancestor is required for this widget to work.
/// Note: this class used to be called [LandingPage].
class AuthWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return StreamBuilder<UserFromFirebase>(
      stream: authService.onAuthStateChanged,
      builder:
          (BuildContext context, AsyncSnapshot<UserFromFirebase> snapshot) {
        final UserFromFirebase? user = snapshot.data;
        if (user != null && !user.isAnonymous) {
          return MultiProvider(
            providers: [
              Provider<UserFromFirebase>.value(value: user),
              // NOTE: Any other user-bound providers here can be added here
            ],
            child: HomePage(),
          );
        } else {
          return FutureBuilder(
            future: authService.currentUser(),
            builder: (context, AsyncSnapshot<UserFromFirebase> snapshot) {
              final UserFromFirebase? localUser = snapshot.data;
              if (localUser != null && !localUser.isAnonymous) {
                return MultiProvider(
                  providers: [
                    Provider<UserFromFirebase>.value(value: localUser),
                    // NOTE: Any other user-bound providers here can be added here
                  ],
                  child: HomePage(),
                );
              }
              return SignInPageBuilder();
            },
          );
        }
      },
    );
  }
}
