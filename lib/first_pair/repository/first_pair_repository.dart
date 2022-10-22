import 'package:shared_preferences/shared_preferences.dart';

const String deviceKey = 'device';

class FirstPairRepository {
  final sharedPreferences = SharedPreferences.getInstance();

  Future<void> saveDevice(String firstPair) async {
    final prefs = await sharedPreferences;
    prefs.setString(deviceKey, firstPair);
  }

  Future<bool> isDeviceExist() async {
    final prefs = await sharedPreferences;
    return prefs.getString(deviceKey) != null;
  }

  Future<String?> getDevice() async {
    final prefs = await sharedPreferences;
    return prefs.getString(deviceKey);
  }
}
