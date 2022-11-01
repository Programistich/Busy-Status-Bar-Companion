import 'package:busy_status_bar/ble/ble_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ble/ble_connection.dart';
import 'ble/ble_scanner.dart';
import 'first_pair/repository/first_pair_repository.dart';
import 'navigation/flow.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final prefs = await SharedPreferences.getInstance();
  final firstPairRepository = FirstPairRepository(prefs);
  final isDeviceExist = await firstPairRepository.isDeviceExist();

  var startPath = firstScreenRoute(isDeviceExist);
  FlutterNativeSplash.remove();

  runApp(App(firstPairRepository: firstPairRepository, startPath: startPath));
}

class App extends StatelessWidget {
  const App(
      {Key? key, required this.firstPairRepository, required this.startPath})
      : super(key: key);

  final FirstPairRepository firstPairRepository;
  final String startPath;

  @override
  Widget build(BuildContext context) {
    final ble = FlutterReactiveBle();
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            create: (context) => ble,
          ),
          RepositoryProvider(
            create: (context) => firstPairRepository,
          ),
          RepositoryProvider(
            create: (context) => BLEScanner(ble),
          ),
          RepositoryProvider(
            create: (context) => BLEConnection(ble),
          ),
          RepositoryProvider(
            create: (context) => BLEService(ble, firstPairRepository),
          ),
        ],
        child: MaterialApp.router(
          routerConfig: navigationFlow(startPath),
          theme: ThemeData(primarySwatch: Colors.blue),
        ));
  }
}
