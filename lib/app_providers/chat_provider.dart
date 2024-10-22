


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_record/app_providers/authentication_provider.dart';
import 'package:firestore_record/source/model/user_model.dart';
import 'package:firestore_record/source/repository/app_repository.dart';
import 'package:flutter/foundation.dart';

import '../dependency_injection.dart';
import '../source/model/chat_model.dart';

import '../source/model/message_model.dart';


enum ChatStatus{initial,loading,loaded,error}

class ChatProvider with ChangeNotifier{
  final IAppRepository iAppRepository;

  ChatProvider({required this.iAppRepository});

  final authPro = sl<AuthenticationProvider>();

  ChatStatus getProfileStatus = ChatStatus.initial;
  ChatStatus addUserChatStatus = ChatStatus.initial;
  ChatStatus chatStatus = ChatStatus.initial;
  ChatStatus sendChatStatus = ChatStatus.initial;
  ChatStatus getChatStatus = ChatStatus.initial;

  List<UserProfileModel> _userProfileList = [];
  List<UserProfileModel> get userProfileList => _userProfileList;
  set setUserProfileList(List<UserProfileModel> value) {
    _userProfileList = value;
    notifyListeners();

  }
   DocumentReference<Map<String, dynamic>>? _chatModel;
  DocumentReference<Map<String, dynamic>>? get chatModel => _chatModel;

  set setChatModel(DocumentReference<Map<String, dynamic>> value) {
    _chatModel = value;
    notifyListeners();
  }



  Future<void> getUserProfile()async{
    getProfileStatus = ChatStatus.loading;
    notifyListeners();
    try{
      setUserProfileList = await iAppRepository.getUserProfiles(userId: authPro.getUserUId.toString());
      getProfileStatus = ChatStatus.loaded;
      notifyListeners();

    }catch(e){
      if (kDebugMode) {
        print("get user profile provider ${e.toString()}");
      }
      getProfileStatus = ChatStatus.error;
      notifyListeners();
    }
  }

  Future<void> addUserChat({required ChatModel chatModel,required String uIds1,required String uIds2}) async {
    addUserChatStatus = ChatStatus.loading;
    notifyListeners();
    try{
      await iAppRepository.addUserChat(chatModel: chatModel, uIds1: uIds1, uIds2: uIds2);
      addUserChatStatus = ChatStatus.loaded;
      notifyListeners();

    } catch (e) {
      if (kDebugMode) {
        print("add user chat provider ${e.toString()}");
      }
      addUserChatStatus = ChatStatus.error;
      notifyListeners();

    }
    return;
  }

  Future<bool> checkChatStatus({required String uIds1,required String uIds2})async{
    chatStatus = ChatStatus.loading;
    notifyListeners();
    try{
      await iAppRepository.checkChatStatus(uIds1: uIds1, uIds2: uIds2);
      chatStatus = ChatStatus.loaded;
      notifyListeners();
    }catch(e){
      chatStatus = ChatStatus.error;
      notifyListeners();
    }
    return false;
  }

  Future<void> sendChat({required String uId1,required String uId2,required Message message})async{
    sendChatStatus = ChatStatus.loading;
    notifyListeners();
    try{
      await iAppRepository.sendChatMessage(uId1: uId1, uId2: uId2, message: message);
      sendChatStatus = ChatStatus.loaded;
      notifyListeners();
    }catch(e){
      if (kDebugMode) {
        print("send chat provider ${e.toString()}");
      }
      sendChatStatus = ChatStatus.error;
      notifyListeners();
    }
  }

  DocumentReference<Map<String, dynamic>>? getChat({required String uId1,required String uId2}){
    getChatStatus = ChatStatus.loading;
    notifyListeners();
    try{
      setChatModel = iAppRepository.getMessage(uId1: uId1, uId2: uId2);
      getChatStatus = ChatStatus.loaded;
      notifyListeners();

    }catch(e){

        print("get chat provider ${e.toString()}");

      getChatStatus = ChatStatus.error;
      notifyListeners();
      throw e.toString();
    }
  }









}