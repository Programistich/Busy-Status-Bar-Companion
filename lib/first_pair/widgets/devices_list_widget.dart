import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/first_pair_bloc.dart';
import '../models/device_list.dart';
import '../widgets/device_item_widget.dart';

class DevicesListWidget extends StatelessWidget {
  final List<Device> devices;
  const DevicesListWidget({super.key, required this.devices});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<FirstPairBloc>();
    final devicesWidget = devices.map(
      (device) => DeviceItem(
        device: device,
        inProgress: device.inProgress,
        onSelected: (device) =>
            bloc..add(FirstPairEventConnect(device: device)),
      ),
    );

    return Expanded(
      child: ListView(
        shrinkWrap: true,
        children: devicesWidget.toList(),
      ),
    );
  }
}
