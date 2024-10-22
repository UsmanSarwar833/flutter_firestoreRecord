import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_record/app_providers/chat_provider.dart';
import 'package:firestore_record/source/core/client_firebase_auth.dart';
import 'package:firestore_record/source/core/client_firebase_firestore.dart';
import 'package:firestore_record/source/data_source/app_setting_local_data_source.dart';
import 'package:firestore_record/source/data_source/authentication_local_data_source.dart';
import 'package:firestore_record/source/data_source/authentication_remote_data_source.dart';
import 'package:firestore_record/source/data_source/remote_data_source.dart';
import 'package:firestore_record/source/repository/app_repository.dart';
import 'package:firestore_record/source/repository/app_setting_repository.dart';
import 'package:firestore_record/source/repository/authentication_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'app_providers/authentication_provider.dart';
import 'app_providers/record_provider.dart';

final GetIt sl = GetIt.instance;

Future<void> setup() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  FirebaseAuth authClient = FirebaseAuth.instance;
  FirebaseFirestore fireStoreClient = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  fireStoreClient.settings = const Settings(persistenceEnabled: true);
  sl.registerLazySingleton<FirebaseAuthClient>( () => FirebaseAuthClient(
      iAuthenticationLocalDataSource : sl(),authClient: authClient,fireStoreClient: fireStoreClient));
  sl.registerLazySingleton<FireStoreClient>(() => FireStoreClient(
      fireStoreClient: fireStoreClient,firebaseStorage: firebaseStorage,iAuthenticationLocalDataSource: sl()));

  ///app settings
  sl.registerLazySingleton<IAppSettingLocalDataSource>(
          () => AppSettingLocalDataSource(sharedPreferences: sharedPreferences));
  sl.registerLazySingleton<IAppSettingRepository>(
          () => AppSettingRepository(iAppSettingLocalDataSource: sl()));

  ///auth
  sl.registerLazySingleton<IAuthenticationRemoteDataSource>(() => AuthenticationRemoteDataSource(firebaseClient: sl()));
  sl.registerLazySingleton<IAuthenticationRepository>(  () => AuthenticationRepository(iAuthenticationLocalDataSource: sl(),iAuthenticationRemoteDataSource: sl()));
  sl.registerLazySingleton<IAuthenticationLocalDataSource>(() => AuthenticationLocalDataSource(sharedPreferences: sharedPreferences));

  ///remote repo
  sl.registerLazySingleton<IAppRepository>( () => AppRepository(remoteDataSource: sl()));
  sl.registerLazySingleton<IRemoteDataSource>(() => RemoteDataSource(fireStoreClient: sl()));

  sl.registerLazySingleton<AuthenticationProvider>( () => AuthenticationProvider(iAuthenticationRepository: sl(),iAppRepository: sl()));
  sl.registerLazySingleton<RecordProvider>( () => RecordProvider(iAppRepository: sl(),));
  sl.registerLazySingleton<ChatProvider>( () => ChatProvider(iAppRepository: sl(),));

}
