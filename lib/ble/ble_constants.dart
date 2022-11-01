import 'dart:typed_data';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BLEConstants {
  static int COMMAND_PREFIX =
      ByteData.sublistView(Uint8List.fromList([0xAA, 0x55])).getUint16(0);

  // UUID сервиса: 0000abf0-0000-1000-8000-00805f9b34fb
  static Uuid service = Uuid.parse('0000abf0-0000-1000-8000-00805f9b34fb');
  // Tx характеристика: 0000abf1-0000-1000-8000-00805f9b34fb - write_no_response
  static Uuid tx = Uuid.parse('0000abf1-0000-1000-8000-00805f9b34fb');
  // Rx характеристика: 0000abf2-0000-1000-8000-00805f9b34fb - notify
  static Uuid rx = Uuid.parse('0000abf2-0000-1000-8000-00805f9b34fb');
}
