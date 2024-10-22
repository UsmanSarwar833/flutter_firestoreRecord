
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_record/core/common/app_utility.dart';
import 'package:firestore_record/source/data_source/authentication_local_data_source.dart';
import 'package:firestore_record/source/model/user_model.dart';
import 'package:flutter/cupertino.dart';

import '../../route/routeString.dart';

class FirebaseAuthClient {
  final IAuthenticationLocalDataSource iAuthenticationLocalDataSource;
  final FirebaseAuth authClient;
  final FirebaseFirestore fireStoreClient;


  FirebaseAuthClient({required this.iAuthenticationLocalDataSource,required this.authClient,required this.fireStoreClient});

  Future<String?> signUpFireBase(BuildContext context,{required String email,required String password,})async{

      try{
       final response = await authClient.createUserWithEmailAndPassword(email: email, password: password);
       //iAuthenticationLocalDataSource.saveUserName(username: response.user!.displayName.toString());

       return response.user!.uid;


      }on FirebaseAuthException catch(e){
        Future.delayed(const Duration(milliseconds: 500),(){
          AppUtility.snackBar(context,message: e.toString());

        });

      }

  }

  Future<UserCredential?> signInFireBase(BuildContext context,{required String email,required String password})async{
    try{
     final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
     iAuthenticationLocalDataSource.saveUserUId(userId: credential.user!.uid.toString());
     Navigator.pushNamedAndRemoveUntil(context, RouteString.mainRoute, (route) => false);

     return credential;

    }on FirebaseAuthException catch(e){
      AppUtility.snackBar(context,message: e.toString());
      print(e);
    }

  }



}