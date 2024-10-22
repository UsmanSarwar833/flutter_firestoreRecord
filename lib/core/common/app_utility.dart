
import 'package:flutter/material.dart';

import '../constant/app_string.dart';

abstract class AppUtility {
  const AppUtility._();

  static const emptyBox = SizedBox.shrink();
  static const loader = Center(child: CircularProgressIndicator.adaptive());
  static void snackBar(BuildContext context,
      {String? message, int seconds = 2}) =>
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message??"no message"), duration: Duration(seconds: seconds)));

  static String? validatePassword(BuildContext context, dynamic value,String password) {
    if (value == null || value.isEmpty) {
      return password;
    }
    if (value.length < 8) {
      return AppString.registerMinPassword;
    }
    if (value.length > 20) {
      return AppString.registerMaxPassword;
    }
    return null;
  }
  static String? validateConfirmPassword(BuildContext context, dynamic value, String password,String confirm) {
    if (value == null || value.isEmpty) {
      return confirm;
    }
    if (value.length < 8) {
      return AppString.registerMinPassword;
    }
    if (value != password) {
      return AppString.registerConfirmPass;
    }

    return null;
  }
  static String? validateEmail(BuildContext context, dynamic value) {
    if (value == null || value.isEmpty) {
      return AppString.emptyEmailField;
    }
    if (!RegExp(r"^((?!\.)[\w_.]*[^.])(@\w+)(\.\w+(\.\w+)?[^.\W])$")
        .hasMatch(value)) {
      return AppString.registerValidEmail;
    }

    return null;
  }

  static String? validateName(BuildContext context, dynamic value,String? validate) {
    if (value == null || value.isEmpty) {
      return validate;
    }
    if (value.length < 3) {
      return AppString.registerNameLength;
    }
    return null;
  }

  static String? validateNumber(BuildContext context, dynamic value,String? validate) {
    if (value == null || value.isEmpty) {
      return validate;
    }
    if (value.length < 10) {
      return AppString.registerNumberLength;
    }
    if (value.length > 10) {
      return AppString.registerNumberLength;
    }
    return null;
  }

}