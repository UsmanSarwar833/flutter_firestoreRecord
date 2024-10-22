import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/common/api_constant.dart';

abstract class IAuthenticationLocalDataSource {
  final SharedPreferences sharedPreferences;

  const IAuthenticationLocalDataSource({required this.sharedPreferences});

  Future<void> saveUserUId({required String userId});
  Future<void> saveUserName({required String username});
  String? getUserUId();
  String? getUserName();

}

class AuthenticationLocalDataSource extends IAuthenticationLocalDataSource {
  const AuthenticationLocalDataSource({required super.sharedPreferences});

  @override
  Future<void> saveUserUId({required String userId}) async {
    await Future.wait([sharedPreferences.setString(AppKeys.userId, userId)]);
  }
  @override
  Future<void> saveUserName({required String username}) async{
    await Future.wait([sharedPreferences.setString(AppKeys.userName, username)]);
  }


  @override
  String? getUserUId() {
    final userId = sharedPreferences.getString(AppKeys.userId);
    return userId;
  }

  @override
  String? getUserName() {
    final userName = sharedPreferences.getString(AppKeys.userName);
    return userName;
  }








}
