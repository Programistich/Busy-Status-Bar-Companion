import 'dart:developer';

import 'package:busy_status_bar/ble/ble_constants.dart';
import 'package:busy_status_bar/ble/protocol/ble_protocol_decoder.dart';
import 'package:busy_status_bar/ble/protocol/ble_protocol_encoder.dart';
import 'package:busy_status_bar/ble/protocol/protocol_requests.dart';
import 'package:busy_status_bar/ble/protocol/protocol_responses.dart';
import 'package:busy_status_bar/first_pair/repository/first_pair_repository.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:image/image.dart';
import 'package:logger/logger.dart';

class BLEService {
  final FlutterReactiveBle _ble;
  final FirstPairRepository repository;
  late final deviceId = repository.getDeviceUnSafe();

  final decoder = BLEProtocolDecoder();
  final encoder = BLEProtocolEncoder();
  final logger = Logger();

  BLEService(this._ble, this.repository) {
    subscribeOnUpdate();
  }

  void subscribeOnUpdate() {
    _ble.subscribeToCharacteristic(_readCharacteristic()).listen((event) {
      logger.d("On event ${event}");
      decoder.onNewBytes(event);
    });
  }

  Future<WiFiListResponse?> getWifis() async {
    subscribeOnUpdate();
    writeRequest(WiFiSearchRequest());
    try {
      final result = await decoder.state
          .where((event) => event is WiFiListResponse)
          .first as WiFiListResponse;
      log('Result wifi response $result');
      return result;
    } on Exception catch (exception) {
      log('Result wifi response error $exception');
      return null;
    }
  }

  Future<WiFiConnectResponse?> connectToWifi(
    String name,
    String password,
  ) async {
    await writeRequest(WiFiConnectRequest(name, password));

    return await decoder.state
        .where((event) => event is WiFiConnectResponse)
        .first as WiFiConnectResponse?;
  }

  Future<ImageResponse?> sendImage(Image image) async {
    await writeRequest(SendImageRequest(image));

    return await decoder.state.where((event) => event is ImageResponse).first
        as ImageResponse?;
  }

  Future<StatusResponse?> getStatus() async {
    await writeRequest(StatusRequest());

    return await decoder.state.where((event) => event is StatusResponse).first
        as StatusResponse?;
  }

  Future<void> writeRequest(BleRequest request) async {
    _ble.writeCharacteristicWithoutResponse(
      _writeCharacteristic(),
      value: encoder.wrapRequest(request),
    );
  }

  QualifiedCharacteristic _readCharacteristic() {
    if (deviceId == null) throw Exception('Device not found');

    return QualifiedCharacteristic(
      characteristicId: BLEConstants.rx,
      serviceId: BLEConstants.service,
      deviceId: deviceId!,
    );
  }

  QualifiedCharacteristic _writeCharacteristic() {
    if (deviceId == null) throw Exception('Device not found');

    return QualifiedCharacteristic(
      characteristicId: BLEConstants.tx,
      serviceId: BLEConstants.service,
      deviceId: deviceId!,
    );
  }
}
