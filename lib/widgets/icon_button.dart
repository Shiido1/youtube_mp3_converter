import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/screens/recorded/provider/record_provider.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';

import 'package:mp3_music_converter/screens/song/provider/music_provider.dart';
import 'package:provider/provider.dart';

class IconButt extends StatefulWidget {
  @override
  _IconButtState createState() => _IconButtState();
}

class _IconButtState extends State<IconButt> {
  String mp3;
  MusicProvider _musicProvider;

  @override
  void initState() {
    super.initState();
    _musicProvider = Provider.of<MusicProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _musicProvider.audioPlayerState == AudioPlayerState.PLAYING
            ? Icons.pause_circle_outline
            : Icons.play_circle_outline,
        size: 56,
      ),
      onPressed: () {
        _musicProvider.handlePlaying();
      },
      color: AppColor.white,
    );
  }
}

class IconButt2 extends StatefulWidget {
  @override
  _IconButt2State createState() => _IconButt2State();
}

class _IconButt2State extends State<IconButt2> {
  String wav;
  RecordProvider _recordProvider;

  @override
  void initState() {
    super.initState();
    _recordProvider = Provider.of<RecordProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _recordProvider.audioPlayerState == AudioPlayerState.PLAYING
            ? Icons.pause_circle_outline
            : Icons.play_circle_outline,
        size: 56,
      ),
      onPressed: () {
        _recordProvider.handlePlaying();
      },
      color: AppColor.white,
    );
  }
}
