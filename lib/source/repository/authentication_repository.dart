
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_record/source/data_source/authentication_local_data_source.dart';
import 'package:firestore_record/source/data_source/authentication_remote_data_source.dart';
import 'package:flutter/material.dart';

import '../model/user_model.dart';

abstract class IAuthenticationRepository {
  final IAuthenticationRemoteDataSource iAuthenticationRemoteDataSource;
  final IAuthenticationLocalDataSource iAuthenticationLocalDataSource;

  IAuthenticationRepository({required this.iAuthenticationRemoteDataSource,
    required this.iAuthenticationLocalDataSource});

  Future<String?> signUp(BuildContext context,{required String email,required String password,});
  Future<UserCredential?> signIn(BuildContext context,{required String email,required String password});

}

class AuthenticationRepository extends IAuthenticationRepository {
  AuthenticationRepository({required super.iAuthenticationRemoteDataSource,
    required super.iAuthenticationLocalDataSource});

  @override
  Future<String?> signUp(BuildContext context,{required String email, required String password,}) async{
    final response =  await iAuthenticationRemoteDataSource.signUp(context,email: email, password: password,);

    return response;
  }

  @override
  Future<UserCredential?> signIn(BuildContext context, {required String email, required String password}) async {
    return await iAuthenticationRemoteDataSource.signIn(context, email: email, password: password);

  }

}