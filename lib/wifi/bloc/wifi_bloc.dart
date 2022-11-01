import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ble/ble_service.dart';
import '../model/wifi_list.dart';

part 'wifi_event.dart';
part 'wifi_state.dart';

class WifiBloc extends Bloc<WifiEvent, WifiState> {
  final BLEService bleService;
  WifiBloc({
    required this.bleService,
  }) : super(WifiInitial(wifis: [])) {
    on<WifiEventInitial>((event, emit) async {
      final response = await bleService.getWifis();

      if (response != null) {
        final wifis = response.wifiList.map((e) => Wifi(name: e.ssid)).toList();
        emit(WifiInitial(wifis: wifis));
      }
    });

    on<WifiEventConnect>((event, emit) async {
      final response = await bleService.connectToWifi(
        event.wifi.name,
        event.password,
      );
      if (response == null) {
        emit(WifiStateError());
      }
      if (response?.successful == true) {
        emit(WifiStateDone());
      } else {
        emit(WifiStateError());
      }
    });
  }
}
