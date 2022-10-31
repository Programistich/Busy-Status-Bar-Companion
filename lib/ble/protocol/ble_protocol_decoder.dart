import 'dart:async';
import 'dart:typed_data';

import 'package:busy_status_bar/ble/ble_constants.dart';
import 'package:busy_status_bar/ble/protocol/protocol_requests.dart';
import 'package:busy_status_bar/ble/protocol/protocol_responses.dart';

class BLEProtocolDecoder {
  ByteData? _pendingData;
  final _controller = StreamController<BleResponse>.broadcast();

  Stream<BleResponse> get state => _controller.stream;

  void onNewBytes(List<int> bytes) {
    final builder = BytesBuilder();

    final pendingData = _pendingData;
    if (pendingData != null) {
      builder.add(pendingData.buffer.asUint8List());
    }

    BleResponse? response;
    ByteDataReader reader =
    ByteDataReader(ByteData.sublistView(Uint8List.fromList(bytes)));
    do {
      response = _parseNewResponse(reader);
      if (response != null) {
        _controller.add(response);
      }
    } while (response != null);

    if (reader.pendingBytes() > 0) {
      final sublist = reader.data.buffer.asUint8List().sublist(reader.offset);
      _pendingData = ByteData.sublistView(sublist);
    }
  }

  BleResponse? _parseNewResponse(ByteDataReader bytes) {
    var prefix = bytes.readUint16();
    if (prefix < 0 && prefix != BLEConstants.COMMAND_PREFIX) {
      return null;
    }
    final commandType = bytes.readUint8();
    if (commandType < 0) {
      return null;
    }
    final length = bytes.readUint32(Endian.little);
    if (length < 0) {
      return null;
    }
    final pendingBytes = bytes.pendingBytes();

    if (length <= pendingBytes) {
      final startOffset = bytes.offset;
      final result = _parseResponse(commandType, bytes);
      bytes.seekToOffset(startOffset + length);
      return result;
    } else if (length == pendingBytes) {
      return _parseResponse(commandType, bytes);
    } else {
      return null;
    }
  }

  BleResponse? _parseResponse(int commandType, ByteDataReader reader) {
    if (commandType == CommandCode.STATUS.code) {
      return StatusResponse(reader);
    }
    return null;
  }
}

class ByteDataReader {
  ByteDataReader(this.data);

  final ByteData data;
  var offset = 0;

  int readUint16([Endian endian = Endian.big]) {
    if (data.lengthInBytes - offset <= 2) {
      return -1;
    }
    final result = data.getUint16(offset, endian);
    offset += 2;
    return result;
  }

  int readUint8() {
    if (data.lengthInBytes - offset <= 1) {
      return -1;
    }
    final result = data.getUint8(offset);
    offset++;
    return result;
  }

  int readUint32([Endian endian = Endian.big]) {
    if (data.lengthInBytes - offset <= 4) {
      return -1;
    }
    final result = data.getUint32(offset, endian);
    offset += 4;
    return result;
  }

  int pendingBytes() {
    return data.lengthInBytes - offset;
  }

  String? readString(int maxLength) {
    final builder = BytesBuilder();
    int index = 0;
    do {
      final readChar = readUint8();
      if (readChar <= 0) {
        if (index == 0) {
          return null;
        } else {
          return String.fromCharCodes(builder.toBytes());
        }
      }
      builder.addByte(readChar);
      index++;
    } while (index < maxLength && offset < data.lengthInBytes - 1);
  }

  void seekToOffset(int requestOffset) {
    if (requestOffset >= data.lengthInBytes) {
      offset = data.lengthInBytes - 1;
    }
    offset = requestOffset;
  }
}
