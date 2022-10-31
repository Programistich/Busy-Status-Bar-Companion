import 'dart:typed_data';

import 'package:busy_status_bar/ble/protocol/protocol_models.dart';

import '../ble_constants.dart';

class BLEProtocolEncoder {
  Uint8List wrapRequest(BleRequest request) {
    final builder = BytesBuilder();

    builder.add(BLEConstants.commandprefix);
    builder.addByte(request
        .commandCode()
        .code);
    final data = request.data();
    builder.addUInt32(data.lengthInBytes);
    builder.add(data.toList());

    return builder.toBytes();
  }
}

extension DataAppend on BytesBuilder {
  void addUInt32(int value, [Endian endian = Endian.little]) {
    final data = ByteData(4);
    data.setUint32(0, value, endian);
    add(data.buffer.asUint8List());
  }

  void addUInt16(int value, [Endian endian = Endian.big]) {
    final data = ByteData(2);
    data.setUint16(0, value, endian);
    add(data.buffer.asUint8List());
  }

  void addString(String value) {
    add(value.runes.toList());
    addByte(0); // End of string
  }
}
