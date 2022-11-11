import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:image/image.dart' as img;
import 'package:logger/logger.dart';

import '../../ble/ble_connection.dart';
import '../../ble/ble_service.dart';
import '../../first_pair/repository/first_pair_repository.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final BLEConnection bleConnection;
  final BLEService bleService;
  final FirstPairRepository firstPairRepository;
  final logger = Logger();

  MainBloc({
    required this.bleConnection,
    required this.firstPairRepository,
    required this.bleService,
  }) : super(MainConnecting()) {
    on<MainEventEntryDisplay>((event, emit) async {
      final deviceId = await firstPairRepository.getDevice();
      if (deviceId == null) return;
      await Future.delayed(const Duration(seconds: 2));
      await bleConnection.connect(deviceId, false);
      await emit.forEach(bleConnection.state, onData: (data) {
        logger.i("Ble connection state in main $state");
        if (data.connectionState == DeviceConnectionState.connected) {
          return MainConnected(id: data.deviceId);
        } else {
          return MainConnecting();
        }
      });
    });

    on<MainEventBusy>((event, emit) async {
      final bytes = await rootBundle.load('resources/test.png');
      final bytesList = bytes.buffer.asUint8List();
      final image = img.decodeImage(bytesList)!;
      await bleService.sendImage(image);
    });
  }
}
