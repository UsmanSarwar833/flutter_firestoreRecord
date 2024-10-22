import 'dart:io';
import 'package:firestore_record/core/common/app_utility.dart';
import 'package:flutter/material.dart';
import '../source/model/add_record.dart';
import '../source/repository/app_repository.dart';

enum RecordStatus { initial, error, loading, loaded }

class RecordProvider with ChangeNotifier {
  final IAppRepository iAppRepository;

  RecordProvider({required this.iAppRepository});

  RecordStatus addRecordStatus = RecordStatus.initial;
  RecordStatus getRecordStatus = RecordStatus.initial;
  RecordStatus postImageStatus = RecordStatus.initial;
  RecordStatus postVideoStatus = RecordStatus.initial;

  List<AddRecordModel> _addRecordModel = [];
  List<AddRecordModel> get addRecordModel => _addRecordModel;
  set addRecordModel(List<AddRecordModel> value) {
    _addRecordModel = value;
  }
  String _audioPath = "";
  String get audioPath => _audioPath;
  set setAudioPath(String value) {
    _audioPath = value;
    notifyListeners();
  }


  String _uploadImage = "";
  String get uploadImage => _uploadImage;
  set setUploadImage(String value) {
    _uploadImage = value;
    notifyListeners();
  }
  String _uploadThumbnail = "";
  String get uploadThumbnail => _uploadThumbnail;

  set setUploadThumbnail(String value) {
    _uploadThumbnail = value;
    notifyListeners();
  }

  String _uploadVideo = "";
  String get uploadVideo => _uploadVideo;
  set setUploadVideo(String value) {
    _uploadVideo = value;
    notifyListeners();
  }



  Future<void> addUserRecord(BuildContext context, {required String userId, required AddRecordModel addRecordModel}) async {
    addRecordStatus = RecordStatus.loading;
    notifyListeners();
    try {
      await iAppRepository.addUserRecord( userId: userId, addRecordModel: addRecordModel);
     setAudioPath = "";

      addRecordStatus = RecordStatus.loaded;
      getUserRecord(userId: userId);
      AppUtility.snackBar(context, message: 'record added successfully');
      Navigator.pop(context);
      notifyListeners();
    } catch (e) {
      addRecordStatus = RecordStatus.error;
      notifyListeners();
    }
  }

  Future<void> getUserRecord({required String userId}) async {
    getRecordStatus = RecordStatus.loading;
    notifyListeners();
    try {
      _addRecordModel = await iAppRepository.getUserRecord(userId: userId);
      getRecordStatus = RecordStatus.loaded;
      notifyListeners();
    } catch (e) {
      getRecordStatus = RecordStatus.error;
      notifyListeners();

    }

  }

  Future<String?> postImage({required File file})async{
    postImageStatus = RecordStatus.loading;
    notifyListeners();
    try{
      setUploadImage = await iAppRepository.postImage(file: file);
      postImageStatus = RecordStatus.loaded;
      notifyListeners();
    }catch(e){
      postImageStatus = RecordStatus.error;
      notifyListeners();
    }

  }
  Future<String?> postThumbnail({required File file})async{
    postImageStatus = RecordStatus.loading;
    notifyListeners();
    try{
      setUploadThumbnail = await iAppRepository.postThumbnail(file: file);

      postImageStatus = RecordStatus.loaded;
      notifyListeners();
    }catch(e){
      postImageStatus = RecordStatus.error;
      notifyListeners();
    }

  }

  Future<String?> postVideo({required File file})async{
    postImageStatus = RecordStatus.loading;
    notifyListeners();
    try{
      setUploadVideo = await iAppRepository.postVideo(file: file);
      postImageStatus = RecordStatus.loaded;
      notifyListeners();
    }catch(e){
      postImageStatus = RecordStatus.error;
      notifyListeners();
    }

  }



}
