import 'package:shared_preferences/shared_preferences.dart';

const String deviceKey = 'device';

class FirstPairRepository {
  final SharedPreferences sharedPreferences;

  FirstPairRepository(this.sharedPreferences);

  Future<void> saveDevice(String firstPair) async {
    sharedPreferences.setString(deviceKey, firstPair);
  }

  Future<bool> isDeviceExist() async {
    return sharedPreferences.getString(deviceKey) != null;
  }

  Future<String?> getDevice() async {
    return sharedPreferences.getString(deviceKey);
  }

  String? getDeviceUnSafe() {
    return sharedPreferences.getString(deviceKey);
  }
}
