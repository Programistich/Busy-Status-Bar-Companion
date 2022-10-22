import 'dart:async';

import 'package:busy_status_bar/ble/ble_connection.dart';
import 'package:busy_status_bar/first_pair/repository/first_pair_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:logger/logger.dart';

import '../../ble/ble_scanner.dart';
import '../models/device_list.dart';

part 'first_pair_event.dart';
part 'first_pair_state.dart';

class FirstPairBloc extends Bloc<FirstPairEvent, FirstPairState> {
  final BLEScanner bleScanner;
  final BLEConnection bleConnection;
  final FirstPairRepository firstPairRepository;

  Device? _connectionDevice;
  List<DiscoveredDevice> currentDevices = [];
  final logger = Logger();

  FirstPairBloc({
    required this.bleScanner,
    required this.bleConnection,
    required this.firstPairRepository,
  }) : super(FirstPairSearching(devices: const [])) {
    bleScanner.startSearch();
    bleScanner.state.where((event) => !isClosed).listen((data) {
      currentDevices = data;
      add(FirstPairEventNewDevice(devices: convert(data)));
    });

    on<FirstPairEventNewDevice>(
      (event, emit) async {
        final devices = event.devices;
        return emit(FirstPairSearching(devices: devices));
      },
    );

    on<FirstPairEventConnect>(
      (event, emit) async {
        final connectedDevice = event.device;
        _connectionDevice = connectedDevice;
        add(FirstPairEventNewDevice(devices: convert(currentDevices)));
        await bleConnection.connect(connectedDevice.id);
        await emit.forEach(bleConnection.state, onData: (data) {
          switch (data.connectionState) {
            case DeviceConnectionState.connecting:
              return state;
            case DeviceConnectionState.connected:
              add(FirstPairEventFinish(device: connectedDevice));
              return state;
            case DeviceConnectionState.disconnecting:
              _connectionDevice = null;
              return state;
            case DeviceConnectionState.disconnected:
              _connectionDevice = null;
              return state;
          }
        });
      },
    );

    on<FirstPairEventFinish>((event, emit) async {
      await firstPairRepository.saveDevice(event.device.id);
      bleConnection.dispose();
      emit(FirstPairConnected());
    });
  }

  List<Device> convert(List<DiscoveredDevice> devices) {
    return devices.map((device) {
      final inProgress = _connectionDevice?.id == device.id;
      return Device(
        id: device.id,
        name: device.name,
        inProgress: inProgress,
      );
    }).toList();
  }

  @override
  Future<void> close() {
    logger.i("Close first pair bloc");
    bleScanner.stopSearch();
    _connectionDevice = null;
    return super.close();
  }
}
