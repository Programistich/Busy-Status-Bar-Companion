import 'dart:typed_data';

class BLEConstants {
  static const String DEVICE_NAME_PREFIX = "Flipper";
  static const String MAC_PREFIX_ANDROID = "80:E1:26:";
  static int COMMAND_PREFIX =
      ByteData.sublistView(Uint8List.fromList([0xAA, 0x55])).getUint16(0);
}

class Service {
  static const String UUID = "0000180f-0000-1000-8000-00805f9b34fb";
  static const String BATTERY_LEVEL_CHARACTERISTIC_UUID =
      "00002a19-0000-1000-8000-00805f9b34fb";
}
