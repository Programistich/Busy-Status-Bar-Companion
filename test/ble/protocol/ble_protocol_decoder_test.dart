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
  test('Parse wifi search response', () async {
    final decoder = BLEProtocolDecoder();
    final resultFuture = decoder.state.first;
    final firstBatchString =
        File('test_resources/wifi_list_1.hex.bytes.txt').readAsStringSync();
    decoder.onNewBytes(HEX.decode(firstBatchString));
    final secondBatchString =
        File('test_resources/wifi_list_2.hex.bytes.txt').readAsStringSync();
    decoder.onNewBytes(HEX.decode(secondBatchString));
    final result = await resultFuture;
    final wifiListResponse = result as WiFiListResponse;
    final wifiList = wifiListResponse.wifiList;
    expect(wifiList.length, equals(20));
    final actualResult = StringBuffer();
    for (var element in wifiList) {
      actualResult
          .write("${element.ssid} ${element.rssi} ${element.security.code}\n");
    }
    final expectedResult =
        File('test_resources/wifi_list.txt').readAsStringSync();
    expect(actualResult.toString(), equals(expectedResult));
  });
  test('Parse connect wifi response', () {});
  test('Parse image response', () {});
}
