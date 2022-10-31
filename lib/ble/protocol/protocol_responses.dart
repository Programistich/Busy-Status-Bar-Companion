import 'dart:io';
import 'dart:typed_data';

import 'package:busy_status_bar/ble/protocol/ble_protocol_decoder.dart';
import 'package:busy_status_bar/ble/protocol/protocol_requests.dart';

abstract class BleResponse {
  CommandCode commandCode();
}

class StatusResponse extends BleResponse {
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
    ssid = reader.readString(32);
  }

  @override
  CommandCode commandCode() {
    return CommandCode.STATUS;
  }
}

enum WiFiSecurity {
  OPEN(0),
  WEP(1),
  WPA_PSK(2),
  WPA2_PSK(3),
  WPA_WPA2_PSK(4),
  WPA2_ENTERPRISE(5),
  WPA3_PSK(6),
  WPA2_WPA3_PSK(7),
  WAPI_PSK(8);

  const WiFiSecurity(this.code);

  final int code;

  static WiFiSecurity? findByCode(int code) {
    for (var element in values) {
      if (code == element.code) {
        return element;
      }
    }
    return null;
  }
}

class WiFiEntry {
  WiFiEntry(this.ssid, this.rssi, this.security);

  final String ssid;
  final int rssi;
  final WiFiSecurity security;
}

class WiFiListResponse extends BleResponse {
  List<WiFiEntry> wifiList = [];

  WiFiListResponse(ByteDataReader reader) {
    final wifiCount = reader.readUint8();
    for (var i = 0; i < wifiCount; i++) {
      final ssid = reader.readString(32);
      final rssi = reader.readInt8();
      final securityCode = reader.readUint8();
      final security = WiFiSecurity.findByCode(securityCode);

      if (ssid == null || rssi == null || security == null) {
        continue;
      }
      wifiList.add(WiFiEntry(ssid, rssi, security));
    }
  }

  @override
  CommandCode commandCode() {
    return CommandCode.WIFISEARCH;
  }
}

class WiFiConnectResponse extends BleResponse {
  bool successful = false;

  WiFiConnectResponse(ByteDataReader reader) {
    successful = reader.readUint8() == 1;
  }

  @override
  CommandCode commandCode() {
    return CommandCode.WIFICONNECT;
  }
}

class ImageResponse extends BleResponse {
  @override
  CommandCode commandCode() {
    return CommandCode.SENDIMAGE;
  }
}
