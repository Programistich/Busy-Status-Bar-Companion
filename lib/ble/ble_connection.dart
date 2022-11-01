import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:logger/logger.dart';

class BLEConnection {
  BLEConnection(this._ble);
  final FlutterReactiveBle _ble;

  final logger = Logger();

  final _controller = StreamController<ConnectionStateUpdate>.broadcast();
  StreamSubscription<ConnectionStateUpdate>? _subscription;
  Stream<ConnectionStateUpdate> get state => _controller.stream;

  Future<void> connect(String deviceId, bool wait) async {
    _subscription = _ble.connectToDevice(id: deviceId).listen(
      (update) async {
        if (update.failure != null) {
          logger.d("Error on connect", update.failure);
          addUpdate(ConnectionStateUpdate(
            deviceId: update.deviceId,
            connectionState: DeviceConnectionState.disconnected,
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
    _subscription = null;
    await _controller.close();
  }
}
