import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../ble/ble_connection.dart';
import '../../first_pair/repository/first_pair_repository.dart';

part 'connection_event.dart';
part 'connection_state.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, ConnectionState> {
  final BLEConnection bleConnection;
  final FirstPairRepository firstPairRepository;

  ConnectionBloc({
    required this.bleConnection,
    required this.firstPairRepository,
  }) : super(ConnectionInitial()) {
    on<ConnectionEventInit>((event, emit) async {
      final deviceId = await firstPairRepository.getDevice();
      if (deviceId == null) return;
      bleConnection.connect(deviceId);
      await emit.forEach(bleConnection.state, onData: (data) {
        return ConnectionInitial();
      });
    });
  }
}
