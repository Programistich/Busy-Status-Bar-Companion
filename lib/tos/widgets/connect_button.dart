import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../navigation/route.dart';

class ConnectButtonWidget extends StatefulWidget {
  const ConnectButtonWidget({super.key});

  @override
  _ConnectButtonWidget createState() => _ConnectButtonWidget();
}

class _ConnectButtonWidget extends State<ConnectButtonWidget> {
  SnackBar textSnackBar(String text) {
    return SnackBar(content: Text(text));
  }

  SnackBar actionSnackBar(String text, String actionText, Function() onClick) {
    return SnackBar(
      content: Text(text),
      action: SnackBarAction(
        label: actionText,
        onPressed: onClick,
      ),
    );
  }

  void show(SnackBar snackBar) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void navigateToDevices() {
    if (!mounted) return;
    context.push(NavigationRoute.firstPairScreen);
  }

  final snackBar = const SnackBar(content: Text('Yay! A SnackBar!'));

  Future<void> requestBluetoothPermission() async {
    if (Platform.isAndroid) {
      final bluetoothScanRequest = await Permission.bluetoothConnect.request();
      if (bluetoothScanRequest.isDenied) {
        SnackBar snackBar = actionSnackBar(
            'Bluetooth permission is denied to connect to a device',
            'Try again',
            () => requestBluetoothPermission());
        show(snackBar);
      }
      if (bluetoothScanRequest.isGranted) {
        // its dirty hack, when user allow bluetoothConnect permission, we request bluetoothScan
        await Permission.bluetoothScan.request();

        final locationStatus = await Permission.locationWhenInUse.serviceStatus;
        if (locationStatus.isEnabled) {
          navigateToDevices();
        } else {
          SnackBar snackBar = actionSnackBar(
              'Location permission is disable to find a device',
              'Open Settings',
              () => Geolocator.openLocationSettings());
          show(snackBar);
        }
      }
      if (bluetoothScanRequest.isPermanentlyDenied) {
        SnackBar snackBar = actionSnackBar(
            'Bluetooth permission is permanently denied to find a device',
            'Open Settings',
            () => openAppSettings());
        show(snackBar);
      }
      if (bluetoothScanRequest.isLimited) {
        SnackBar snackBar = textSnackBar(
            'Bluetooth permission is limited denied to find a device. Contact to developer');
        show(snackBar);
      }
      if (bluetoothScanRequest.isRestricted) {
        SnackBar snackBar = textSnackBar(
            'Bluetooth permission is restricted denied to find a device. Contact to developer');
        show(snackBar);
      }
    } else if (Platform.isIOS) {
      final bluetoothStatus = await Permission.bluetooth.request();
      if (bluetoothStatus.isDenied) {
        SnackBar snackBar = actionSnackBar(
            'Bluetooth permission is denied to connect to a device',
            'Try again',
            () => requestBluetoothPermission());
        show(snackBar);
      }
      if (bluetoothStatus.isGranted) {
        navigateToDevices();
      }
      if (bluetoothStatus.isPermanentlyDenied) {
        SnackBar snackBar = actionSnackBar(
            'Bluetooth permission is permanently denied to find a device',
            'Open Settings',
            () => openAppSettings());
        show(snackBar);
      }
      if (bluetoothStatus.isLimited) {
        SnackBar snackBar = textSnackBar(
            'Bluetooth permission is limited denied to find a device. Contact to developer');
        show(snackBar);
      }
      if (bluetoothStatus.isRestricted) {
        SnackBar snackBar = textSnackBar(
            'Bluetooth permission is restricted denied to find a device. Contact to developer');
        show(snackBar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: requestBluetoothPermission,
        child: const Text('Connect'),
      ),
    );
  }
}
