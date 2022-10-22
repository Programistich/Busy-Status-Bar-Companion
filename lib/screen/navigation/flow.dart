// import 'package:flutter/cupertino.dart';
// import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
// import 'package:go_router/go_router.dart';
//
// import '../connect/connect_screen.dart';
// import '../connecting/connecting_screen.dart';
// import '../list_devices/list_device_screen.dart';
// import '../main/main_screen.dart';
// import 'route.dart';
//
// GoRouter navigationFlow(String startPath) {
//     return GoRouter(
//       initialLocation : startPath,
//       routes: <GoRoute>[
//         GoRoute(
//             path: NavigationRoute.connectScreen,
//             builder: (BuildContext context, GoRouterState state) =>
//             const ConnectScreen()
//         ),
//         GoRoute(
//             path: NavigationRoute.listDevices,
//             builder: (BuildContext context, GoRouterState state) =>
//             const ListDevicesScreen()
//         ),
//         GoRoute(
//             path: NavigationRoute.confirmConnectionScreen,
//             builder: (BuildContext context, GoRouterState state) => ConnectingScreen(device: state.extra as DiscoveredDevice)
//         ),
//         GoRoute(
//             path: NavigationRoute.mainScreen,
//             builder: (BuildContext context, GoRouterState state) =>
//             const MainScreen()
//         )
//       ],
//     );
// }
