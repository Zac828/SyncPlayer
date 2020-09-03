import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sync_video/home/home_bloc.dart';
import 'package:sync_video/manager/floating_button_manager.dart';
import 'package:sync_video/view/configue_form.dart';
import 'package:sync_video/view/video_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeBloc _homeBlocFirst;
  HomeBloc _homeBlocSecond;

  FloatingButtonManager _floatingButtonManager;

  @override
  void initState() {
    super.initState();

    _homeBlocFirst = HomeBloc();
    _homeBlocSecond = HomeBloc();

    _floatingButtonManager = FloatingButtonManager();
  }

  @override
  Widget build(BuildContext context) {
    int _action = 0;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FlutterLogo(colors: Colors.deepOrange),
        ),
        title: Text('影片同步播放器'),
        actions: [
          GestureDetector(
            onTap: () {
              _homeBlocFirst.add(HomeResetEvent());
              _homeBlocSecond.add(HomeResetEvent());
            },
            child: Container(
              margin: EdgeInsets.only(right: 16),
              child: Icon(Icons.refresh)
            ),
          )
        ],
      ),
      body: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          return orientation == Orientation.portrait
              ? _buildVerticalLayout()
              : _buildHorizontalLayout();
        },
      ),
      floatingActionButton: MultiBlocListener(
        listeners: [
          BlocListener(
            listener: (BuildContext context, state) {
              if (state is HomeConfiguredState || state is HomePlayerState) {
                _floatingButtonManager.stateSubjectSink.add(1);
              } else {
                _floatingButtonManager.stateSubjectSink.add(-1);
              }
            },
            cubit: _homeBlocFirst,
          ),
          BlocListener(
            listener: (BuildContext context, state) {
              if (state is HomeConfiguredState) {
                _floatingButtonManager.stateSubjectSink.add(2);
              } else if (state is HomePlayerState) {
                _action = state.action;
                _floatingButtonManager.stateSubjectSink.add(2);
              } else {
                _action = 0;
                _floatingButtonManager.stateSubjectSink.add(-2);
              }
            },
            cubit: _homeBlocSecond,
          )
        ],
        child: StreamBuilder(
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) return Container();

            if (snapshot.data) {
              if (_action == 1) {
                return FloatingActionButton(
                  onPressed: () {
                    _homeBlocFirst.add(HomePauseEvent());
                    _homeBlocSecond.add(HomePauseEvent());
                  },
                  child: Icon(Icons.pause),
                );
              } else {
                return FloatingActionButton(
                onPressed: () {
                  _homeBlocFirst.add(HomePlayEvent());
                  _homeBlocSecond.add(HomePlayEvent());
                  },
                  child: Icon(Icons.play_arrow),
                );
              }
            } else {
              return Container();
            }
          },
          stream: _floatingButtonManager.buildFloatingButton$,
        ),
      ),
    );
  }

  Widget _buildVerticalLayout() {
    return Column(
      children: [
        Expanded(
          child: _buildContent(1)
        ),
        Expanded(
          child: _buildContent(2)
        ),
      ],
    );
  }

  Widget _buildHorizontalLayout() {
    return Row(
      children: [
        Expanded(
          child: _buildContent(1)
        ),
        Expanded(
          child: _buildContent(2)
        ),
      ],
    );
  }

  Widget _buildContent(int where) {
    HomeBloc _bloc;
    if ((where == 1)) {
      _bloc = _homeBlocFirst;
    } else {
      _bloc = _homeBlocSecond;
    }

    return BlocBuilder(
      builder: (BuildContext context, state) {
        if (state is HomeInitialState) {
          return Center(
            child: RaisedButton(
              onPressed: () {
                _bloc.add(HomeLoadingEvent());
              },
              child: Text('讀取',
                style: TextStyle(
                  fontSize: 30,
                )
              )
            ),
          );
        } else if (state is HomeLoadingFileState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is HomeConfiguringState) {
          return ConfigureForm(bloc: _bloc);
        } else if (state is HomeConfiguredState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('準備播放', style: TextStyle(fontSize: 36)),
              Text('快轉至 ${state.minute}:${state.second}.${state.millisecond} 處'
                , style: TextStyle(fontSize: 20)
              ),
              Text('速度: ${state.speed} 倍'),
              RaisedButton(
                onPressed: () {
                  _bloc.add(HomeConfiguringEvent());
                },
                child: Text('取消', style: TextStyle(fontSize: 20)),
              )
            ],
          );
        } else if (state is HomePlayerState) {
          String _url = state.url;
            return VideoScreen(
              url: _url,
              msec: state.msec,
              speed: state.speed,
              bloc: _bloc
            );
        } else {
          return Center(child: Text('Error'));
        }
      },
      cubit: _bloc,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _homeBlocFirst.close();
    _homeBlocSecond.close();

    _floatingButtonManager.dispose();
  }
}
