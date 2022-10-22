// import 'package:busy_status_bar/service/ble_scanner.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
//
// import '../navigation/route.dart';
//
// class ListDevicesScreen extends StatelessWidget {
//   const ListDevicesScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) => Consumer2<BLEScanner, BLEScannerModel?>(
//           builder: (_, bleScanner, bleScanState, __) {
//         return Scaffold(
//           appBar: AppBar(title: const Text('List Devices')),
//           body: _ListDevices(
//             startSearch: bleScanner.startSearch,
//             stopSearch: bleScanner.stopSearch,
//             state: bleScanState ?? const BLEScannerModel(devices: [])
//           ),
//         );
//       });
// }
//
// class _ListDevices extends StatefulWidget {
//   const _ListDevices({required this.startSearch, required this.stopSearch, required this.state});
//
//   final BLEScannerModel state;
//   final void Function() startSearch;
//   final void Function() stopSearch;
//
//   @override
//   ListDevices createState() => ListDevices();
// }
//
// class ListDevices extends State<_ListDevices> {
//
//   @override
//   void initState() {
//     super.initState();
//     widget.startSearch();
//   }
//
//   @override
//   void dispose() {
//     widget.stopSearch();
//     print("dispose list device");
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//         child: ListView(
//           children: widget.state.devices.map((device) =>  ListTile(
//             title: Text(device.name),
//             subtitle: Text("Id: ${device.id}"),
//             leading: const Icon(Icons.bluetooth),
//             onTap: () {
//               context.push(NavigationRoute.confirmConnectionScreen, extra: device);
//             }
//           )).toList()
//       )
//     );
//   }
// }
