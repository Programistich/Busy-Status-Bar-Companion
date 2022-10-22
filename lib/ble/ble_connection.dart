import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:logger/logger.dart';

class BLEConnection {
  BLEConnection(this._ble);
  final FlutterReactiveBle _ble;

  final logger = Logger();

  final _controller = StreamController<ConnectionStateUpdate>();
  StreamSubscription<ConnectionStateUpdate>? _subscription;
  Stream<ConnectionStateUpdate> get state => _controller.stream;

  Future<void> connect(String deviceId) async {
    _subscription = _ble.connectToDevice(id: deviceId).listen(
      (update) async {
        if (update.failure != null) {
          logger.d("Error on connect", update.failure);
          addUpdate(ConnectionStateUpdate(
            deviceId: update.deviceId,
            connectionState: DeviceConnectionState.disconnected,
            failure: null,
          ));
        } else if (update.connectionState == DeviceConnectionState.connected) {
          addUpdate(ConnectionStateUpdate(
            deviceId: update.deviceId,
            connectionState: DeviceConnectionState.connecting,
            failure: null,
          ));
          await Future.delayed(const Duration(seconds: 25));
          addUpdate(ConnectionStateUpdate(
            deviceId: update.deviceId,
            connectionState: DeviceConnectionState.connected,
            failure: null,
          ));
        } else {
          addUpdate(update);
        }
      },
      onError: (error) {
        logger.e("Error connecting to device: $error");
      },
    );
  }

  void addUpdate(ConnectionStateUpdate update) {
    logger.d("State update new state: $update");
    _controller.add(update);
  }

  Future<void> dispose() async {
    logger.i("Stop process connect to device");
    _subscription?.cancel();
    await _controller.close();
  }
}

// final characteristic = QualifiedCharacteristic(
//   characteristicId:
//       Uuid.parse('00002a28-0000-1000-8000-00805f9b34fb'),
//   serviceId: Uuid.parse('0000180a-0000-1000-8000-00805f9b34fb'),
//   deviceId: deviceId,
// );
// _ble.subscribeToCharacteristic(characteristic).listen((event) {
//   print(event);
// });
// addUpdate(ConnectionStateUpdate(
//   deviceId: update.deviceId,
//   connectionState: DeviceConnectionState.connecting,
//   failure: null,
// ));
// await Future.delayed(const Duration(seconds: 10));
// try {
//   final characteristic = QualifiedCharacteristic(
//     characteristicId:
//         Uuid.parse('00002a28-0000-1000-8000-00805f9b34fb'),
//     serviceId: Uuid.parse('0000180a-0000-1000-8000-00805f9b34fb'),
//     deviceId: update.deviceId,
//   );
//   logger.i("Start read characteristic");
//   final readCharacteristic =
//       await _ble.readCharacteristic(characteristic);
//   logger.i("Read characteristic: $readCharacteristic.");
//   addUpdate(ConnectionStateUpdate(
//     deviceId: update.deviceId,
//     connectionState: DeviceConnectionState.connected,
//     failure: null,
//   ));
// } on Exception catch (exception) {
//   logger.d("Error when try get services", exception);
//   addUpdate(ConnectionStateUpdate(
//     deviceId: update.deviceId,
//     connectionState: DeviceConnectionState.disconnected,
//     failure: null,
//   ));
// }
