part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class HomeResetEvent extends HomeEvent {}

class HomeLoadingEvent extends HomeEvent {}

class HomeConfiguringEvent extends HomeEvent {}

class HomeConfigDoneEvent extends HomeEvent {
  final int minute;
  final int second;
  final int millisecond;

  HomeConfigDoneEvent({this.minute, this.second, this.millisecond});
}

class HomePlayEvent extends HomeEvent {}