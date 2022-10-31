import 'package:busy_status_bar/ble/ble_connection.dart';
import 'package:busy_status_bar/first_pair/bloc/first_pair_bloc.dart';
import 'package:busy_status_bar/first_pair/repository/first_pair_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:go_router/go_router.dart';

import '../../ble/ble_scanner.dart';
import '../../navigation/route.dart';
import '../widgets/devices_list_widget.dart';
import '../widgets/searching_title_widget.dart';

class FirstPairPage extends StatelessWidget {
  const FirstPairPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bleScanner = context.read<BLEScanner>();
        final ble = context.read<FlutterReactiveBle>();
        final bleConnection = BLEConnection(ble);
        final repository = context.read<FirstPairRepository>();
        return FirstPairBloc(
          bleScanner: bleScanner,
          bleConnection: bleConnection,
          firstPairRepository: repository,
        );
      },
      child: BlocBuilder<FirstPairBloc, FirstPairState>(
        builder: (context, state) {
          List<Widget> bodyContent = [];

          if (state is FirstPairSearching) {
            bodyContent.add(const SearchingTitleWidget());
            bodyContent.add(DevicesListWidget(devices: state.devices));
          }

          if (state is FirstPairConnected) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go(NavigationRoute.mainScreen);
            });
          }

          return Scaffold(
            appBar: AppBar(title: const Text('Find Device')),
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
