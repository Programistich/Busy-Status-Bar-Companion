import 'dart:typed_data';

import 'package:busy_status_bar/ble/protocol/ble_protocol_encoder.dart';
import 'package:image/image.dart';

abstract class BleRequest {
  CommandCode commandCode();

  Uint8List data();
}

enum CommandCode {
  STATUS(0),
  WIFISEARCH(1),
  WIFICONNECT(2),
  SENDIMAGE(3);

  const CommandCode(this.code);

  final int code;
}

class StatusRequest extends BleRequest {
  @override
  CommandCode commandCode() {
    return CommandCode.STATUS;
  }

  @override
  Uint8List data() {
    return Uint8List(0);
  }
}

class WiFiSearchRequest extends BleRequest {
  @override
  CommandCode commandCode() {
    return CommandCode.WIFISEARCH;
  }

  @override
  Uint8List data() {
    return Uint8List(0);
  }
}

class WiFiConnectRequest extends BleRequest {
  WiFiConnectRequest(this.ssid, this.password);

  final String ssid;
  final String password;

  @override
  CommandCode commandCode() {
    return CommandCode.WIFICONNECT;
  }

  @override
  Uint8List data() {
    final builder = BytesBuilder();
    builder.addString(ssid);
    builder.addString(password);
    return builder.toBytes();
  }
}

class SendImageRequest extends BleRequest {
  SendImageRequest(this.image);

  Image image;

  @override
  CommandCode commandCode() {
    return CommandCode.SENDIMAGE;
  }

  @override
  Uint8List data() {
    final builder = BytesBuilder();

    for (int height = 0; height < image.height; height++) {
      for (int width = 0; width < image.width; width++) {
        final color = image.getPixel(width, height);
        final rgb565 = (((getRed(color) & 0xf8) << 8) +
            ((getGreen(color) & 0xfc) << 3) +
            (getBlue(color) >> 3));
        builder.addUInt16(rgb565);
      }
    }
    return builder.toBytes();
  }
}
