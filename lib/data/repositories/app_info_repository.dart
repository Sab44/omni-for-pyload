import 'package:omni_for_pyload/domain/repositories/i_app_info_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppInfoRepository implements IAppInfoRepository {
  @override
  Future<String> getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}
