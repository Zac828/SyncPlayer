import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';

class VideoScreen extends StatefulWidget {
  final String url;
  final double msec;

  VideoScreen({@required this.url, this.msec});

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
      child: FijkView(
        player: player,
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
