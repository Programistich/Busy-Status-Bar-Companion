import 'package:busy_status_bar/first_pair/repository/first_pair_repository.dart';
import 'package:busy_status_bar/wifi/bloc/wifi_bloc.dart';
import 'package:busy_status_bar/wifi/widgtes/wifi_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ble/ble_service.dart';

class WifiPage extends StatelessWidget {
  const WifiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bleService = context.read<BLEService>();
        final repository = context.read<FirstPairRepository>();
        return WifiBloc(bleService: bleService, repository: repository)
          ..add(WifiEventInitial());
      },
      child: BlocBuilder<WifiBloc, WifiState>(
        builder: (context, state) {
          List<Widget> bodyContent = [];

          if (state is WifiInitial) {
            bodyContent.add(WifiListWidget(wifis: state.wifis));
          }

          return Scaffold(
            appBar: AppBar(title: const Text('Wifi Screen')),
            body: Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 16.0,
              ),
              child: Column(
                children: bodyContent,
              ),
            ),
          );
        },
      ),
    );
  }
}
