import 'dart:async';
import 'dart:typed_data';

import 'package:busy_status_bar/ble/ble_constants.dart';
import 'package:busy_status_bar/ble/protocol/protocol_requests.dart';
import 'package:busy_status_bar/ble/protocol/protocol_responses.dart';

class BLEProtocolDecoder {
  Uint8List? _pendingData;
  final _controller = StreamController<BleResponse>.broadcast();

  Stream<BleResponse> get state => _controller.stream;

  void onNewBytes(List<int> bytes) {
    final builder = BytesBuilder();

    final pendingData = _pendingData;
    if (pendingData != null) {
      builder.add(pendingData);
    }
    builder.add(bytes);

    BleResponse? response;
    ByteDataReader reader =
        ByteDataReader(ByteData.sublistView(builder.toBytes()));
    int offset = 0;
    do {
      offset = reader.offset; // Remember offset if reader failed
      response = _parseNewResponse(reader);
      if (response != null) {
        _controller.add(response);
      }
    } while (response != null);

    if (reader.pendingBytes() > 0) {
      _pendingData = reader.data.buffer.asUint8List().sublist(offset);
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
    } else if (commandType == CommandCode.WIFISEARCH.code) {
      return WiFiListResponse(reader);
    } else if (commandType == CommandCode.WIFICONNECT.code) {
      return WiFiConnectResponse(reader);
    } else if (commandType == CommandCode.SENDIMAGE.code) {
      return ImageResponse();
    }
    return null;
  }
}

class ByteDataReader {
  ByteDataReader(this.data);

  final ByteData data;
  var offset = 0;

  int readUint16([Endian endian = Endian.big]) {
    if (data.lengthInBytes - offset < 2) {
      return -1;
    }
    final result = data.getUint16(offset, endian);
    offset += 2;
    return result;
  }

  int? readInt8() {
    if (data.lengthInBytes - offset < 1) {
      return null;
    }
    final result = data.getInt8(offset);
    offset++;
    return result;
  }

  int readUint8() {
    if (data.lengthInBytes - offset < 1) {
      return -1;
    }
    final result = data.getUint8(offset);
    offset++;
    return result;
  }

  int readUint32([Endian endian = Endian.big]) {
    if (data.lengthInBytes - offset < 4) {
      return -1;
    }
    final result = data.getUint32(offset, endian);
    offset += 4;
    return result;
  }

  int pendingBytes() {
    return data.lengthInBytes - offset;
  }

  String? readString(int length) {
    final builder = BytesBuilder();
    int expectedOffset = offset + length;
    int index = 0;
    do {
      final readChar = readUint8();
      if (readChar <= 0) {
        if (index == 0) {
          seekToOffset(expectedOffset);
          return null;
        } else {
          seekToOffset(expectedOffset);
          return String.fromCharCodes(builder.toBytes());
        }
      }
      builder.addByte(readChar);
      index++;
    } while (index < length && offset < data.lengthInBytes - 1);
    seekToOffset(expectedOffset);
    return String.fromCharCodes(builder.toBytes());
  }

  void seekToOffset(int requestOffset) {
    if (requestOffset >= data.lengthInBytes) {
      offset = data.lengthInBytes - 1;
    }
    offset = requestOffset;
  }
}
