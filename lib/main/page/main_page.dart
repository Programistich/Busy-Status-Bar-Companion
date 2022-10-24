import 'package:busy_status_bar/ble/ble_connection.dart';
import 'package:busy_status_bar/ble/ble_service.dart';
import 'package:busy_status_bar/first_pair/repository/first_pair_repository.dart';
import 'package:busy_status_bar/main/bloc/main_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import '../widgets/connected_title_widget.dart';
import '../widgets/connecting_title_widget.dart';
import '../widgets/ping_button_widget.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bleService = context.read<BLEService>();
        final ble = context.read<FlutterReactiveBle>();
        final bleConnection = BLEConnection(ble);
        final repository = context.read<FirstPairRepository>();
        return MainBloc(
          bleService: bleService,
          bleConnection: bleConnection,
          firstPairRepository: repository,
        )..add(MainEventEntryDisplay());
      },
      child: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          List<Widget> bodyContent = [];

          if (state is MainConnecting) {
            bodyContent.add(const ConnectingTitleWidget());
          }

          if (state is MainConnected) {
            bodyContent.add(ConnectedTitleWidget(name: state.id));
            bodyContent.add(const PingButtonWidget());
          }

          return Scaffold(
            appBar: AppBar(title: const Text('Main Screen')),
            body: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
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
