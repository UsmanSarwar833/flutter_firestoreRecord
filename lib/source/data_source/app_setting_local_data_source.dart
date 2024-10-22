import 'package:shared_preferences/shared_preferences.dart';

abstract class IAppSettingLocalDataSource {
  final SharedPreferences sharedPreferences;

  const IAppSettingLocalDataSource({required this.sharedPreferences});
}

class AppSettingLocalDataSource extends IAppSettingLocalDataSource {
  AppSettingLocalDataSource({required super.sharedPreferences});
}