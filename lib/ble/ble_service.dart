import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:logger/logger.dart';

class BLEService {
  BLEService(this._ble);

  final FlutterReactiveBle _ble;

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
}
