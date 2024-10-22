import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../core/client_firebase_auth.dart';
import '../model/user_model.dart';

abstract class IAuthenticationRemoteDataSource {
  final FirebaseAuthClient firebaseClient;

  IAuthenticationRemoteDataSource({required this.firebaseClient});

  Future<String?> signUp(BuildContext context,{required String email,required String password,});
  Future<UserCredential?> signIn(BuildContext context,{required String email,required String password});



}

class AuthenticationRemoteDataSource extends IAuthenticationRemoteDataSource {
  AuthenticationRemoteDataSource({required super.firebaseClient});

  @override
  Future<String?> signUp(BuildContext context,{required String email, required String password,}) async{
   final response =  await firebaseClient.signUpFireBase(context, email: email, password: password,);

   return response;
  }

  @override
  Future<UserCredential?> signIn(BuildContext context, {required String email, required String password})async {
    return await firebaseClient.signInFireBase(context, email: email, password: password);


  }


}