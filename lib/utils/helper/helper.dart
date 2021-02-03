import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';

void showToast(BuildContext context,
    {@required String message, int gravity = 0}) {
  Toast.show(message, context,
      backgroundRadius: 10, duration: 4, gravity: gravity);
}

/// @ validate email
bool validateEmail(String email) {
  String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regExp = new RegExp(p);

  var status = regExp.hasMatch(email);
  return status;
}

bool isPasswordCompliant(String password, [int minLength = 8]) {
  if (password == null || password.isEmpty) {
    return false;
  }

  // bool _hasUppercase = password.contains(new RegExp(r'[A-Z]'));
  bool _hasDigits = password.contains(new RegExp(r'[0-9]'));
  bool _hasLowercase = password.contains(new RegExp(r'[a-z]'));
  // bool hasSpecialCharacters = password.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  bool _hasMinLength = password.length >= minLength;
  return _hasDigits & _hasLowercase & _hasMinLength;
}
