import 'package:rxdart/rxdart.dart';

class FloatingButtonManager {
  BehaviorSubject _floatingSubject = BehaviorSubject<bool>.seeded(false);
  ValueStream<bool> get buildFloatingButton$ => _floatingSubject.stream;

  PublishSubject _checkStateSubject = PublishSubject<int>();
  Sink get stateSubjectSink => _checkStateSubject.sink;

  bool _flagFirstReady = false;
  bool _flagSecondReady = false;

  FloatingButtonManager() {
    _checkStateSubject.listen((value) {
      if (value == 1) {
        _flagFirstReady = true;
      } else if (value == -1) {
        _flagFirstReady = false;
      }
      if (value == 2) {
        _flagSecondReady = true;
      } else if (value == -2) {
        _flagSecondReady = false;
      }

      if (_flagFirstReady && _flagSecondReady) {
        _floatingSubject.add(true);
      } else {
        _floatingSubject.add(false);
      }
    });
  }

  dispose() {
    _floatingSubject.close();
    _checkStateSubject.close();
  }
}