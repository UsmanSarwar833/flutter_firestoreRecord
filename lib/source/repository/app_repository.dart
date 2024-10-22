import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_record/source/data_source/remote_data_source.dart';
import 'package:firestore_record/source/model/chat_model.dart';
import 'package:firestore_record/source/model/user_model.dart';

import '../model/add_record.dart';
import '../model/message_model.dart';

abstract class IAppRepository {
  final IRemoteDataSource remoteDataSource;

  const IAppRepository({required this.remoteDataSource});

  ///Record

  Future<void> addUserRecord({required String userId,required AddRecordModel addRecordModel});
  Future<List<AddRecordModel>> getUserRecord({required String userId});
  Future<String> postImage({required File file});
  Future<String> postVideo({required File file});
  Future<String> postThumbnail({required File file});

  ///chat

  Future<void> addUser({required UserProfileModel userModel});
  Future<UserProfileModel> getUser({required String userId});
  Future<void> addUserChat({required ChatModel chatModel,required String uIds1,required String uIds2});
  Future<List<UserProfileModel>> getUserProfiles({required String userId});
  Future<bool> checkChatStatus({required String uIds1,required String uIds2});
  Future<void> sendChatMessage({required String uId1,required String uId2,required Message message});
  DocumentReference<Map<String, dynamic>> getMessage({required String uId1,required String uId2});

}

class AppRepository extends IAppRepository {
  const AppRepository({required super.remoteDataSource});

  ///Record

  @override
  Future<void> addUserRecord({required String userId, required AddRecordModel addRecordModel}) async{
    return await remoteDataSource.addUserRecord(userId: userId, addRecordModel: addRecordModel);
  }

  @override
  Future<List<AddRecordModel>> getUserRecord({required String userId}) async{
    final response =  await remoteDataSource.getUserRecord(userId: userId);
    return response;
  }

  @override
  Future<String> postImage({required File file}) async {
    final response =  await remoteDataSource.postImage(file: file);
    return response;
  }

  @override
  Future<String> postVideo({required File file}) async {
    final response =  await remoteDataSource.postVideo(file: file);
    return response;
  }

  @override
  Future<String> postThumbnail({required File file}) async {
    final response =  await remoteDataSource.postThumbnail(file: file);

    return response;
  }

  ///Chat

  @override
  Future<void> addUser({required UserProfileModel userModel}) async {
    return await remoteDataSource.addUser( userModel: userModel);

  }

  @override
  Future<List<UserProfileModel>> getUserProfiles({required String userId}) async{
   return await remoteDataSource.getUserProfiles(userId: userId);
  }

  @override
  Future<void> addUserChat({required ChatModel chatModel,required String uIds1,required String uIds2}) async{
    return await remoteDataSource.addUserChat(chatModel: chatModel, uIds1: uIds1, uIds2: uIds2);
  }

  @override
  Future<bool> checkChatStatus({required String uIds1, required String uIds2}) async{
   return await remoteDataSource.checkChatStatus(uIds1: uIds1, uIds2: uIds2);
  }

  @override
  Future<UserProfileModel> getUser({required String userId}) async {
    return await remoteDataSource.getUser(userId: userId);
  }

  @override
  Future<void> sendChatMessage({required String uId1, required String uId2, required Message message}) async{
    return await remoteDataSource.sendChatMessage(uId1: uId1, uId2: uId2, message: message);
  }

  @override
  DocumentReference<Map<String, dynamic>> getMessage({required String uId1, required String uId2}) {
    return remoteDataSource.getMessage(uId1: uId1, uId2: uId2);
  }
}