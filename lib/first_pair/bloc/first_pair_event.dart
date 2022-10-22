part of 'first_pair_bloc.dart';

@immutable
abstract class FirstPairEvent {}

class FirstPairEventConnect extends FirstPairEvent {
  final Device device;

  FirstPairEventConnect({required this.device});
}

class FirstPairEventNewDevice extends FirstPairEvent {
  final List<Device> devices;

  FirstPairEventNewDevice({required this.devices});
}

class FirstPairEventFinish extends FirstPairEvent {
  final Device device;

  FirstPairEventFinish({required this.device});
}
