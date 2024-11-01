import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

extension StringExtension on String {
  String translate(BuildContext context) {
    return FlutterI18n.translate(context, this);
  }
}
