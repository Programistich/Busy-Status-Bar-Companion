part of 'wifi_bloc.dart';

abstract class WifiEvent {}

class WifiEventInitial extends WifiEvent {}

class WifiEventConnect extends WifiEvent {
  final Wifi wifi;
  final String password;
  WifiEventConnect({required this.wifi, required this.password});
}
