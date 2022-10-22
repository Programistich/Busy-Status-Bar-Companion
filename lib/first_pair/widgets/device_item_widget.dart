import 'package:flutter/material.dart';

import '../models/device_list.dart';

class DeviceItem extends StatelessWidget {
  final Device device;
  final bool inProgress;
  final Function(Device) onSelected;

  const DeviceItem({
    required this.device,
    required this.inProgress,
    required this.onSelected,
    Key? key,
  }) : super(key: key);

  void selectDevice() {}

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          const Icon(Icons.bluetooth),
          if (device.name.isEmpty) Text(device.id),
          Text(device.name),
          const Spacer(),
          if (inProgress)
            const SizedBox(
              height: 20.0,
              width: 20.0,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
          if (!inProgress)
            SizedBox(
              height: 30.0,
              child: ElevatedButton(
                onPressed: () => {onSelected(device)},
                child: const Text('Connect'),
              ),
            ),
        ],
      ),
    );
  }
}
