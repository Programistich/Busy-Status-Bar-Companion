import 'dart:io';
import 'dart:typed_data';

import 'package:busy_status_bar/ble/protocol/ble_protocol_decoder.dart';
import 'package:busy_status_bar/ble/protocol/protocol_requests.dart';

abstract class BleResponse {
  CommandCode commandCode();
}

class StatusResponse extends BleResponse {
  static const _SSID_MAX_STRING_SIZE = 32;
  int version = -1;
  int width = -1;
  int height = -1;
  bool wifiConnected = false;
  String? ssid;

  StatusResponse(ByteDataReader reader) {
    version = reader.readUint8();
    width = reader.readUint8();
    height = reader.readUint8();
    wifiConnected = reader.readUint8() == 1;
    ssid = reader.readString(_SSID_MAX_STRING_SIZE);
  }

  @override
  CommandCode commandCode() {
    return CommandCode.STATUS;
  }
}
