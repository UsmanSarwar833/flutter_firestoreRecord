import '../data_source/app_setting_local_data_source.dart';

abstract class IAppSettingRepository {
  final IAppSettingLocalDataSource iAppSettingLocalDataSource;

  const IAppSettingRepository({required this.iAppSettingLocalDataSource});
}

class AppSettingRepository extends IAppSettingRepository {
  const AppSettingRepository({required super.iAppSettingLocalDataSource});

}