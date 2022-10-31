import 'package:busy_status_bar/ble/protocol/ble_protocol_encoder.dart';
import 'package:busy_status_bar/ble/protocol/protocol_requests.dart';
import 'package:hex/hex.dart';
import 'package:test/test.dart';
import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  test('Build device status packet', () {
    final encoder = BLEProtocolEncoder();
    final expectedBytes = HEX.decode("AA550000000000");
    final actualBytes = encoder.wrapRequest(StatusRequest());
    expect(actualBytes.toList(), equals(expectedBytes));
  });
  test('Build wifi search packet', () {
    final encoder = BLEProtocolEncoder();
    final expectedBytes = HEX.decode("AA550100000000");
    final actualBytes = encoder.wrapRequest(WiFiSearchRequest());
    expect(actualBytes.toList(), equals(expectedBytes));
  });
  test('Build connect wifi packet', () {
    final encoder = BLEProtocolEncoder();
    final expectedBytes = HEX.decode("AA55020C000000746573740031323334353600");
    final actualBytes =
        encoder.wrapRequest(WiFiConnectRequest('test', '123456'));
    expect(actualBytes.toList(), equals(expectedBytes));
  });
  test('Build image packet', () {
    final encoder = BLEProtocolEncoder();
    final imageFile = File('test_resources/test.png');
    final expectedBytesText =
        File('test_resources/test_image.hex.bytes.txt').readAsStringSync();
    final expectedBytes = HEX.decode(expectedBytesText);
    final image = img.decodeImage(imageFile.readAsBytesSync())!;
    final actualBytes = encoder.wrapRequest(SendImageRequest(image));
    expect(actualBytes.toList(), equals(expectedBytes));
  });
}
