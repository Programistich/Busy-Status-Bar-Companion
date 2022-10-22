part of 'first_pair_bloc.dart';

@immutable
abstract class FirstPairState {}

class FirstPairSearching extends FirstPairState {
  final List<Device> devices;

  FirstPairSearching({required this.devices});
}

class FirstPairConnected extends FirstPairState {}
