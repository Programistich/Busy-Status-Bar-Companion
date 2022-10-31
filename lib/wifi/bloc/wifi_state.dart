part of 'wifi_bloc.dart';

abstract class WifiState {}

class WifiInitial extends WifiState {
  final List<Wifi> wifis;
  WifiInitial({required this.wifis});
}
