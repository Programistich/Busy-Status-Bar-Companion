import 'package:busy_status_bar/wifi/bloc/wifi_bloc.dart';
import 'package:busy_status_bar/wifi/widgtes/wifi_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/wifi_list.dart';

class WifiListWidget extends StatelessWidget {
  final List<Wifi> wifis;
  const WifiListWidget({super.key, required this.wifis});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<WifiBloc>();
    final wifisWidget = wifis.map(
      (wifi) => WifiItem(
          wifi: wifi,
          onConnect: (wifi, password) =>
              bloc..add(WifiEventConnect(wifi: wifi, password: password))),
    );

    return Expanded(
      child: ListView(
        shrinkWrap: true,
        children: wifisWidget.toList(),
      ),
    );
  }
}
