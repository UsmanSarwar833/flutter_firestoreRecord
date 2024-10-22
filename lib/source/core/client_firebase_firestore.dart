import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_record/core/common/api_constant.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firestore_record/core/utils.dart';
import 'package:firestore_record/source/model/chat_model.dart';
import 'package:firestore_record/source/model/message_model.dart';

import '../data_source/authentication_local_data_source.dart';
import '../model/add_record.dart';
import '../model/user_model.dart';

class FireStoreClient {
  final FirebaseFirestore fireStoreClient;
  final FirebaseStorage firebaseStorage;
  final IAuthenticationLocalDataSource iAuthenticationLocalDataSource;


  FireStoreClient( {required this.fireStoreClient, required this.firebaseStorage,required this.iAuthenticationLocalDataSource});

   ///record

  Future<void> addUserRecord({required String userId, required AddRecordModel addRecordModel}) async {
    try {
      await fireStoreClient
          .collection(ApiConstant.userRecord)
          .doc(userId)
          .collection(ApiConstant.addRecord)
          .doc()
          .set(addRecordModel.toJson());
    } catch (e) {
      print("addUserRecordFireStore ${e.toString()}");
    }
    //return;
  }
  ///m

  Future<List<AddRecordModel>> getUserRecord({required String userId}) async {
    List<AddRecordModel> getRecordList = [];
    try {
      final result = await fireStoreClient
          .collection(ApiConstant.userRecord)
          .doc(userId)
          .collection(ApiConstant.addRecord)
          .get();

      for (var record in result.docs) {
        getRecordList.add(AddRecordModel.fromJson(record.data()));
      }

      return getRecordList;
    } catch (e) {
      return getRecordList;
    }
  }

  Future<String> postImage({required File file}) async {
    String imageUrl = "";

    ///get a reference to storage to uploaded image
    Reference ref = firebaseStorage
        .ref().child("images").child("${DateTime.now().day.toString()}-${DateTime.now().month.toString()}-${DateTime.now().year.toString()}")
        .child(DateTime.now().toString());
    try {
      /// store the file
      await ref.putFile(File(file.path));

      ///get the download url
      imageUrl = await ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print(e.toString());
      return imageUrl;
    }
  }

  Future<String> postVideo({required File file}) async {
    String videoUrl = "";

    ///get a reference to storage to uploaded video
    Reference ref = firebaseStorage
        .ref()
        .child("videos url")
        .child(
            "${DateTime.now().day.toString()}-${DateTime.now().month.toString()}-${DateTime.now().year.toString()}")
        .child(DateTime.now().toString());
    try {
      /// store the file
      await ref.putFile(File(file.path));

      ///get the download url
      videoUrl = await ref.getDownloadURL();
      return videoUrl;
    } catch (e) {
      print(e.toString());
      return videoUrl;
    }
  }

  Future<String> postThumbnail({required File file}) async {
    String imageUrl = "";

    ///get a reference to storage to uploaded thumbnail
    Reference ref = firebaseStorage
        .ref()
        .child("thumbnail")
        .child(
            "${DateTime.now().day.toString()}-${DateTime.now().month.toString()}-${DateTime.now().year.toString()}")
        .child(DateTime.now().toString());
    try {
      /// store the file
      await ref.putFile(File(file.path));

      ///get the download url
      imageUrl = await ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print(e.toString());
      return imageUrl;
    }
  }


  ///chat

  Future<void> addUser({required UserProfileModel userModel}) async {
    try {
      await fireStoreClient.collection(ApiConstant.user).doc() .set(userModel.toJson());
    } catch (e) {
      print("add user ${e.toString()}");
    }
  }

  Future<UserProfileModel> getUser({required String userId}) async {
    UserProfileModel userProfile = UserProfileModel.empty();
    try {
      final result = await fireStoreClient.collection(ApiConstant.user).where("uId", isEqualTo: userId).get();
      for(var user in result.docs){
          userProfile = UserProfileModel.fromMap(user.data());
      }
      iAuthenticationLocalDataSource.saveUserName(username: userProfile.name.toString());

      return userProfile;
    } catch (e) {
      print("get user ${e.toString()}");
      return userProfile;

    }
  }

  Future<List<UserProfileModel>> getUserProfiles(  {required String userId}) async {
    List<UserProfileModel> userProfileList = [];
    try {
      final result = await fireStoreClient.collection(ApiConstant.user).where("uId", isNotEqualTo: userId) .get();
      for (var user in result.docs) {
        userProfileList.add(UserProfileModel.fromMap(user.data()));
      }
      return userProfileList;
    } catch (e) {
      print("user profile ${e.toString()}");
      return userProfileList;
    }
  }

  Future<void> addUserChat ({required ChatModel chatModel,required String uIds1,required String uIds2}) async {
    try {
      String chatId = generateChatId(uid1: uIds1, uid2: uIds2,);
      await fireStoreClient.collection(ApiConstant.chat).doc(chatId).set(chatModel.toJson());

    } catch (e) {
      print("add user chat ${e.toString()}");
    }
  }

  Future<List<ChatModel>> getUserChat() async {
    List<ChatModel> chatModelList = [];
    try {
      final result = await fireStoreClient.collection(ApiConstant.chat).get();
      for (var user in result.docs) {
        chatModelList.add(ChatModel.fromJson(user.data()));
      }
      return chatModelList;
    } catch (e) {
      print("user chat list  ${e.toString()}");
      return chatModelList;
    }
  }

  Future<bool> checkChatStatus({required String uIds1,required String uIds2})async{
  //  final CollectionReference chatCollection;
  // chatCollection = fireStoreClient.collection(ApiConstant.chat).withConverter<ChatModel>(
    // fromFirestore: (snapshots,_) => ChatModel.fromJson(snapshots.data()!),
    // toFirestore: (chat,_) => chat.toJson());

    String chatId = generateChatId(uid1: uIds1, uid2: uIds2);
    final result = await fireStoreClient.collection(ApiConstant.chat).doc(chatId).get();

   // final result = await chatCollection.doc(chatId).get();
    if(result != null){
      return result.exists;
    }else{
      return false;
    }

  }

  Future<void> sendChatMessage({required String uId1,required String uId2,required Message message})async{
    try{
      String chatId = generateChatId(uid1: uId1, uid2: uId2);
      print(chatId);
      await fireStoreClient.collection(ApiConstant.chat).doc(chatId).update({
        "messages" : FieldValue.arrayUnion([message.toJson()]),
      });
    }catch(e){
      print("chat message ${e.toString()}");

    }
    
  }

  DocumentReference<Map<String, dynamic>> getMessage({required String uId1,required String uId2}){
    try{
      String chatId = generateChatId(uid1: uId1, uid2: uId2);
      return fireStoreClient.collection(ApiConstant.chat).doc(chatId);

      }catch(e){
      print("chat message ${e.toString()}");
      throw e.toString();
    }
  }
}
