import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/wifi_list.dart';

part 'wifi_event.dart';
part 'wifi_state.dart';

class WifiBloc extends Bloc<WifiEvent, WifiState> {
  WifiBloc() : super(WifiInitial(wifis: [])) {
    emit(WifiInitial(
        wifis: [Wifi(name: "Hack Tesla"), Wifi(name: "Buy Twitter")]));
  }
}
