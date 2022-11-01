part of 'main_bloc.dart';

@immutable
abstract class MainEvent {}

class MainEventEntryDisplay extends MainEvent {}

class MainEventPing extends MainEvent {}

class MainEventState extends MainEvent {
  final ConnectionStateUpdate stateUpdate;

  MainEventState({required this.stateUpdate});
}

class MainEventBusy extends MainEvent {}
