part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class HomeResetEvent extends HomeEvent {}

class HomeLoadingEvent extends HomeEvent {}

class HomeConfiguringEvent extends HomeEvent {}

class HomeConfigDoneEvent extends HomeEvent {
  final int minute;
  final int second;

  HomeConfigDoneEvent({this.minute, this.second});
}

class HomePlayEvent extends HomeEvent {}