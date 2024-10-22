import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/common/app_utility.dart';


class ParsedException implements Exception {
  const ParsedException();
}

class UnauthorizedException implements Exception {
  const UnauthorizedException();
}

whenExceptionCatch(BuildContext context, Exception e) {
  if (e is FirebaseAuthException) {
    print("${e.code}: ${e.message}");
    switch(e.code){
      case "user-not-found":
        AppUtility.snackBar(context, message: "No user found for that email");
        break;
      case "wrong-password":
        AppUtility.snackBar(context, message: "Wrong password provided for that user");
        break;
      case 'invalid-email':
        AppUtility.snackBar(context, message: "Your email format is wrong");
        break;
      default: {
        print("Stack trace: ${e.code}: ${e.stackTrace.toString()}");
        AppUtility.snackBar(context, message: "Failed: ${e.message}");
        break;
      }
    }
  }

  if (e is ParsedException) {
    AppUtility.snackBar(context, message: "Parse Error");
  }
  if (e is UnauthorizedException) {}
}