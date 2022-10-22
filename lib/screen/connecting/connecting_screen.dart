// import 'package:busy_status_bar/service/ble_connection.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
//
// import '../navigation/route.dart';
//
// class ConnectingScreen extends StatelessWidget {
//   final DiscoveredDevice device;
//
//   const ConnectingScreen({super.key, required this.device});
//
//   @override
//   Widget build(BuildContext context) =>
//       Consumer2<BLEConnection, ConnectionStateUpdate>(
//           builder: (_, bleConnect, connectionState, __) {
//         return Scaffold(
//           appBar: AppBar(title: Text('Connecting to ${device.id}')),
//           body: _Connecting(
//             startConnect: bleConnect.connect(device.id),
//             state: connectionState,
//             dispose: bleConnect.dispose,
//             checkPair: bleConnect.checkConnection,
//           ),
//         );
//       });
// }
//
// class _Connecting extends StatefulWidget {
//   const _Connecting({
//     required this.startConnect,
//     required this.state,
//     required this.dispose,
//     required this.checkPair
//   });
//
//   final ConnectionStateUpdate state;
//   final void Function() dispose;
//   final Future<void> startConnect;
//   final Future<bool> Function(String) checkPair;
//   final bool isPair = false;
//
//   @override
//   Connecting createState() => Connecting();
// }
//
// class Connecting extends State<_Connecting> {
//   @override
//   void initState() {
//     super.initState();
//     widget.startConnect;
//   }
//
//   @override
//   void dispose() {
//     widget.dispose();
//     super.dispose();
//   }
//
//   void onPressConnected(String deviceId) async {
//     bool isPairingCode = await widget.checkPair(deviceId);
//     if (isPairingCode) {}
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         if (kDebugMode) Text(widget.state.toString()),
//         if (widget.state.connectionState == DeviceConnectionState.connecting)
//           const CircularProgressIndicator(),
//         if (widget.state.connectionState == DeviceConnectionState.connected)
//           ElevatedButton(
//               onPressed: () => onPressConnected(widget.state.deviceId),
//               child: const Text('Connected')
//           ),
//         if (widget.state.connectionState == DeviceConnectionState.disconnected)
//           const Text('Disconnected'),
//         if (widget.state.connectionState == DeviceConnectionState.disconnecting)
//           const Text('Disconnecting'),
//         if (widget.state.failure != null)
//           Text('Error: ${widget.state.failure!.message}'),
//         if (!widget.isPair)
//           ElevatedButton(
//               onPressed: () => onPressConnected(widget.state.deviceId),
//               child: const Text('Try again')
//           ),
//       ],
//     );
//   }
// }
