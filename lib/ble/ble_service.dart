import 'package:busy_status_bar/ble/ble_constants.dart';
import 'package:busy_status_bar/ble/protocol/ble_protocol_decoder.dart';
import 'package:busy_status_bar/ble/protocol/ble_protocol_encoder.dart';
import 'package:busy_status_bar/ble/protocol/protocol_requests.dart';
import 'package:busy_status_bar/ble/protocol/protocol_responses.dart';
import 'package:busy_status_bar/first_pair/repository/first_pair_repository.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:logger/logger.dart';

class BLEService {
  final FlutterReactiveBle _ble;
  final FirstPairRepository repository;

  final decoder = BLEProtocolDecoder();
  final encoder = BLEProtocolEncoder();
  final logger = Logger();

  BLEService(this._ble, this.repository) {
    final deviceId = repository.getDeviceUnSafe();
    if (deviceId != null) {
      _ble
          .subscribeToCharacteristic(readCharacteristic(deviceId))
          .listen((event) {
        decoder.onNewBytes(event);
      });
    }
  }

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
    _ble.writeCharacteristicWithoutResponse(
      writeCharacteristic(deviceId),
      value: encoder.wrapRequest(WiFiSearchRequest()),
    );

    return await decoder.state
        .where((event) => event is WiFiConnectResponse)
        .first;
  }
}

QualifiedCharacteristic readCharacteristic(String deviceId) {
  return QualifiedCharacteristic(
    characteristicId: BLEConstants.service,
    serviceId: BLEConstants.rx,
    deviceId: deviceId,
  );
}

QualifiedCharacteristic writeCharacteristic(String deviceId) {
  return QualifiedCharacteristic(
    characteristicId: BLEConstants.service,
    serviceId: BLEConstants.tx,
    deviceId: deviceId,
  );
}
