import 'package:busy_status_bar/first_pair/repository/first_pair_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ble/ble_service.dart';
import '../../ble/protocol/protocol_responses.dart';
import '../model/wifi_list.dart';

part 'wifi_event.dart';
part 'wifi_state.dart';

class WifiBloc extends Bloc<WifiEvent, WifiState> {
  final BLEService bleService;
  final FirstPairRepository repository;
  WifiBloc({
    required this.bleService,
    required this.repository,
  }) : super(WifiInitial(wifis: [])) {
    on<WifiEventInitial>((event, emit) async {
      final deviceId = await repository.getDevice();
      if (deviceId == null) return;

      final response = await bleService.getWifis(deviceId);
      if (response is WiFiListResponse) {
        final wifis = response.wifiList.map((e) => Wifi(name: e.ssid)).toList();
        emit(WifiInitial(wifis: wifis));
      }
    });
  }
}
