import 'dart:async';

import 'package:get/get.dart';
import 'package:invoc/src/language/language_keys.dart';
import 'package:invoc/v3/auth/common_widgets/platform_alert_dialog.dart';
import 'package:invoc/v3/auth/constants/strings.dart';
import 'package:invoc/v3/auth/services/firebase_email_link_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Listens to [errorStream] and shows an alert dialog each time an error is received.
/// This widget should live for the entire lifecycle of the app, so that all errors are reported.
class EmailLinkErrorPresenter extends StatefulWidget {
  const EmailLinkErrorPresenter({ this.child, this.errorStream});
  final Widget? child;
  final Stream<EmailLinkError>? errorStream;

  static Widget create(BuildContext context, {Widget? child}) {
    final FirebaseEmailLinkHandler linkHandler =
        Provider.of<FirebaseEmailLinkHandler>(context, listen: false);
    return EmailLinkErrorPresenter(
      child: child,
      errorStream: linkHandler.errorStream,
    );
  }

  @override
  _EmailLinkErrorPresenterState createState() =>
      _EmailLinkErrorPresenterState();
}

class _EmailLinkErrorPresenterState extends State<EmailLinkErrorPresenter> {
   StreamSubscription<EmailLinkError>? _onEmailLinkErrorSubscription;

  @override
  void initState() {
    super.initState();
    _onEmailLinkErrorSubscription = widget.errorStream!.listen((error) {
      PlatformAlertDialog(
        title: Strings.activationLinkError,
        content: error.message,
        defaultActionText: okKey.tr,
      ).show(context);
    });
  }

  @override
  void dispose() {
    _onEmailLinkErrorSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child!;
  }
}
