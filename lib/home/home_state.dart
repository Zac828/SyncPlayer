part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitialState extends HomeState {}

class HomeLoadingFileState extends HomeState {}

class HomeConfiguringState extends HomeState {
}

class HomeConfiguredState extends HomeState {
  final int minute;
  final int second;
  final int millisecond;
  final double speed;

  HomeConfiguredState({this.minute, this.second, this.millisecond, this.speed});
}

class HomePlayerState extends HomeState {
  // 1: play, 2: pause, 3: stop
  final int action;
  final String url;
  final double msec;
  final double speed;

  HomePlayerState({this.action, this.url, this.msec, this.speed});
}