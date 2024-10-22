import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_record/core/common/app_utility.dart';
import 'package:firestore_record/route/routeString.dart';
import 'package:firestore_record/source/data_source/authentication_local_data_source.dart';
import 'package:firestore_record/source/model/chat_model.dart';
import 'package:firestore_record/source/model/user_model.dart';
import 'package:firestore_record/source/repository/app_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/common/api_constant.dart';
import '../source/core/exceptions.dart';
import '../source/repository/authentication_repository.dart';

enum AuthStatus { initial, error, loading, loaded }

class AuthenticationProvider with ChangeNotifier {
  final IAuthenticationRepository iAuthenticationRepository;
  final IAppRepository iAppRepository;

  AuthenticationProvider(
      {required this.iAuthenticationRepository, required this.iAppRepository});

  AuthStatus signUpStatus = AuthStatus.initial;
  AuthStatus addUserStatus = AuthStatus.initial;
  AuthStatus getUserStatus = AuthStatus.initial;
  AuthStatus signInStatus = AuthStatus.initial;
  AuthStatus logOutStatus = AuthStatus.initial;

  String? get getUserUId {
    return iAuthenticationRepository.iAuthenticationLocalDataSource
        .getUserUId();
  }

  String? get getUserName {
    return iAuthenticationRepository.iAuthenticationLocalDataSource
        .getUserName();
  }


  Future<String?> signUp(BuildContext context,
      {
      required String email,
      required String password,
     }) async {
    signUpStatus = AuthStatus.loading;
    notifyListeners();
    try {

      final response =  await iAuthenticationRepository.signUp(context,
          email: email,
          password: password,
          );

      signUpStatus = AuthStatus.loaded;
      notifyListeners();
      return response;
    } on FirebaseAuthException catch (e) {
      signUpStatus = AuthStatus.error;
      notifyListeners();
      whenExceptionCatch(context, e);
    }
  }

  Future<void> addUser({required UserProfileModel userModel}) async {
    addUserStatus = AuthStatus.loading;
    notifyListeners();
    try{
       await iAppRepository.addUser( userModel: userModel);
       addUserStatus = AuthStatus.loaded;
      notifyListeners();

    } catch (e) {
      addUserStatus = AuthStatus.error;
      notifyListeners();

    }
    return;
  }

  Future<void> getUser({required String userId}) async {
    getUserStatus = AuthStatus.loading;
    notifyListeners();
    try{
      await iAppRepository.getUser(userId: userId);
      getUserStatus = AuthStatus.loaded;
      notifyListeners();

    } catch (e) {
      getUserStatus = AuthStatus.error;
      notifyListeners();

    }
    return;
  }







  Future<void> signIn(BuildContext context,
      {required String email, required String password}) async {
    signInStatus = AuthStatus.loading;
    notifyListeners();
    try {
      await iAuthenticationRepository.signIn(context,
          email: email, password: password);
      await iAppRepository.getUser(userId: getUserUId.toString());
      signInStatus = AuthStatus.loaded;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      signInStatus = AuthStatus.error;
      notifyListeners();
      whenExceptionCatch(context, e);
    }
    return;
  }

  Future<void> logOut(BuildContext context) async {
    logOutStatus = AuthStatus.loading;
    notifyListeners();
    try {
      await iAuthenticationRepository
          .iAuthenticationLocalDataSource.sharedPreferences
          .remove(AppKeys.userId);
      logOutStatus = AuthStatus.loaded;
      notifyListeners();
      if (getUserUId == null) {
        Navigator.pushNamedAndRemoveUntil(
            context, RouteString.signInRoute, (route) => false);
        AppUtility.snackBar(context, message: "Log out successfully");
      }
    } catch (e) {
      logOutStatus = AuthStatus.error;
      notifyListeners();
      print("log out exception${e.toString()}");
    }
  }
}
