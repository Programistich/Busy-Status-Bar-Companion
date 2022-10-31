import 'package:busy_status_bar/ble/ble_constants.dart';
import 'package:busy_status_bar/ble/protocol/ble_protocol_decoder.dart';
import 'package:busy_status_bar/ble/protocol/ble_protocol_encoder.dart';
import 'package:busy_status_bar/ble/protocol/protocol_responses.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:logger/logger.dart';

class BLEService {
  BLEService(this._ble);

  final FlutterReactiveBle _ble;
  final decoder = BLEProtocolDecoder();
  final encoder = BLEProtocolEncoder();

  final logger = Logger();

  Future<void> ping(String deviceId) async {
    final characteristic = QualifiedCharacteristic(
      characteristicId: Uuid.parse('19ed82ae-ed21-4c9d-4145-228e62fe0000'),
      serviceId: Uuid.parse('8fe5b3d5-2e7f-4a98-2a48-7acc60fe0000'),
      deviceId: deviceId,
    );
    final value = <int>[3, -78, 2, 0];
    _ble.writeCharacteristicWithoutResponse(characteristic, value: value);
  }

  Future<BleResponse> getWifis(String deviceId) async {
    final characteristic = notifyCharacteristic(deviceId);
    _ble.subscribeToCharacteristic(characteristic).listen((event) {
      logger.d(event);
      decoder.onNewBytes(event);
    });
    return decoder.state.first;
  }
}

QualifiedCharacteristic notifyCharacteristic(String deviceId) {
  return QualifiedCharacteristic(
    characteristicId: BLEConstants.service,
    serviceId: BLEConstants.rx,
    deviceId: deviceId,
  );
}
