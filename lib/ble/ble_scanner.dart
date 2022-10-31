import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:logger/logger.dart';

class BLEScanner {
  BLEScanner(this._ble);

  final FlutterReactiveBle _ble;

  final logger = Logger();

  final _controller = StreamController<List<DiscoveredDevice>>.broadcast();
  Stream<List<DiscoveredDevice>> get state => _controller.stream;
  StreamSubscription? _subscription;

  void startSearch() {
    final devices = <DiscoveredDevice>[];
    logger.d("Start ble search");
    devices.clear();
    _subscription?.cancel();
    _subscription = _ble.scanForDevices(
      withServices: [],
      scanMode: ScanMode.lowLatency,
    ).listen((device) {
      if (deviceCanPair(device)) {
        final knownDeviceIndex = devices.indexWhere((it) => it.id == device.id);
        if (knownDeviceIndex >= 0) {
          devices[knownDeviceIndex] = device;
        } else {
          logger.d("New find device with id ${device.id}");
          devices.add(device);
        }
        _controller.add(
          devices,
        );
      }
    }, onError: (error) => logger.e("Error when scan devices", error));
  }

  bool deviceCanPair(DiscoveredDevice device) {
    // return device.name.startsWith("BusyLamp");
    return true;
  }

  Future<void> stopSearch() async {
    logger.d("Stop ble search");
    await _subscription?.cancel();
    _subscription = null;
    _controller.add([]);
  }
}
