import 'package:busy_status_bar/ble/protocol/ble_protocol_decoder.dart';
import 'package:busy_status_bar/ble/protocol/ble_protocol_encoder.dart';
import 'package:busy_status_bar/ble/protocol/protocol_responses.dart';
import 'package:hex/hex.dart';
import 'package:test/test.dart';
import 'dart:io';

void main() {
  test('Parse device status response', () async {
    final decoder = BLEProtocolDecoder();
    final bytes = HEX.decode(
        "AA550024000000004008016E6575726F6E0000000000000000000000000000000000000000000000000000");
    final resultFuture = decoder.state.first;
    decoder.onNewBytes(bytes);
    final result = await resultFuture;
    final statusResponse = result as StatusResponse;
    expect(statusResponse.version, equals(0));
    expect(statusResponse.width, equals(64));
    expect(statusResponse.height, equals(8));
    expect(statusResponse.wifiConnected, equals(true));
    expect(statusResponse.ssid, equals("neuron"));
  });
  test('Parse wifi search response', () {});
  test('Parse connect wifi response', () {});
  test('Parse image response', () {});
}
