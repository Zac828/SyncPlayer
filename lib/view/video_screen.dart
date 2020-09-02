import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sync_video/home/home_bloc.dart';

class VideoScreen extends StatefulWidget {
  final String url;
  final double msec;
  final HomeBloc bloc;

  VideoScreen({@required this.url, this.msec, this.bloc});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final FijkPlayer player = FijkPlayer();

  bool _isFirst = true;

  @override
  void initState() {
    super.initState();
    player.addListener(_fijkValueListener);
    autoStart();
  }

  void autoStart() async {
    await player.setOption(FijkOption.hostCategory, "request-screen-on", 1);
    await player.setOption(FijkOption.hostCategory, "request-audio-focus", 1);
    await player.setDataSource(widget.url, autoPlay: true);
  }

  void _fijkValueListener() {
    FijkValue value = player.value;

    if (value.videoRenderStart && _isFirst) {
      _isFirst = false;
      player.seekTo(widget.msec.toInt());
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: BlocListener(
        listener: (BuildContext context, state) {
          if (state is HomePlayerState) {
            if (state.action == 2) {
              player.pause();
            } else {
              if (player.isPlayable()) {
                player.start();
              }
            }
          }
        },
        child: FijkView(
          player: player,
          fit: FijkFit.cover,
        ),
        cubit: widget.bloc,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    release();
  }

  void release() async {
    await player.stop();
    await player.release();
    player.dispose();
  }
}
