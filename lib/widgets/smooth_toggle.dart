import 'package:flutter/material.dart';
import 'package:invoc/utils/invoc_app_theme.dart';

class SmoothToggle extends StatelessWidget {
  const SmoothToggle({required this.value, this.onChanged});

  final bool value;
  final Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Switch(
      activeColor: InvocAppTheme.nearlyDarkBlue,
      value: value,
      onChanged: onChanged,
    );
  }
}
