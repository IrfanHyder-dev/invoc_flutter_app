import 'package:invoc/v3/auth/common_widgets/custom_raised_button.dart';
import 'package:flutter/material.dart';

class FormSubmitButton extends CustomRaisedButton {
  FormSubmitButton({

    String? text,
    bool loading = false,
    VoidCallback? onPressed, Key? key,
  }) : super(
          child: Text(
            text!,
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          height: 44.0,
          color: Colors.indigo,
          textColor: Colors.black87,
          loading: loading,
          onPressed:(onPressed != null)? onPressed : null,
        );
}
