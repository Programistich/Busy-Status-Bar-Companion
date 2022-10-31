part of 'main_bloc.dart';

@immutable
abstract class MainState {}

class MainConnecting extends MainState {}

class MainConnected extends MainState {
  final String id;
  MainConnected({required this.id});
}
