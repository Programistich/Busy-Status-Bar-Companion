import 'dart:typed_data';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BLEConstants {
  static const String DEVICE_NAME_PREFIX = "Flipper";
  static const String MAC_PREFIX_ANDROID = "80:E1:26:";
  static int COMMAND_PREFIX =
      ByteData.sublistView(Uint8List.fromList([0xAA, 0x55])).getUint16(0);

  static Uuid service = Uuid.parse('0000abf0-0000-1000-8000-00805f9b34fb');
  static Uuid tx = Uuid.parse('0000abf1-0000-1000-8000-00805f9b34fb');
  static Uuid rx = Uuid.parse('0000abf2-0000-1000-8000-00805f9b34fb');
}
