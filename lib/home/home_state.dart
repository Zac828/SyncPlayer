part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitialState extends HomeState {}

class HomeLoadingFileState extends HomeState {}

class HomeConfiguringState extends HomeState {
}

class HomeConfiguredState extends HomeState {
}

class HomePlayerState extends HomeState {
  // 1: play, 2: pause, 3: stop
  final int action;
  final String url;
  final double msec;

  HomePlayerState({this.action, this.url, this.msec});
}