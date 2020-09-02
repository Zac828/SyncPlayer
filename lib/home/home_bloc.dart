import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  String _url;

  int _minute = 0, _second = 0, _millisecond = 0;

  HomeBloc() : super(HomeInitialState());

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is HomeResetEvent) {
      yield* _mapInitToState();
    } else if (event is HomeLoadingEvent) {
      yield* _mapLoadingToState();
    } else if (event is HomeConfiguringEvent) {
      yield* _mapConfiguringToState();
    } else if (event is HomeConfigDoneEvent) {
      yield* _mapConfigDoneToState(event.minute, event.second, event.millisecond);
    } else if (event is HomePlayEvent) {
      yield* _mapPlayToState();
    } else if (event is HomePauseEvent) {
      yield* _mapPauseToState();
    }
  }

  Stream<HomeState> _mapInitToState() async* {
    _minute = 0;
    _second = 0;

    yield HomeInitialState();
  }

  Stream<HomeState> _mapLoadingToState() async* {
    yield HomeLoadingFileState();

    _url = await FilePicker.getFilePath(type: FileType.video);
    if (_url == null) {
      yield HomeInitialState();
    } else {
      yield HomeConfiguringState();
    }
  }

  Stream<HomeState> _mapConfiguringToState() async* {
    _minute = 0;
    _second = 0;

    yield HomeConfiguringState();
  }

  Stream<HomeState> _mapConfigDoneToState(minute, second, millisecond) async* {
    _minute = minute;
    _second = second;
    _millisecond = millisecond;

    yield HomeConfiguredState(minute: _minute, second: _second, millisecond: _millisecond);
  }

  Stream<HomeState> _mapPlayToState() async* {

    double _msec = _minute * 60 + _second + (_millisecond / 10);

    yield HomePlayerState(action: 1, url: _url, msec: _msec * 1000);
  }

  Stream<HomeState> _mapPauseToState() async* {
    yield HomePlayerState(action: 2, url: _url, msec: -1.0);
  }
}
