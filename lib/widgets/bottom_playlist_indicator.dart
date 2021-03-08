import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mp3_music_converter/database/model/log.dart';
import 'package:mp3_music_converter/database/repository/log_repository.dart';
import 'package:mp3_music_converter/screens/song/song_view.dart';
import 'package:mp3_music_converter/widgets/app_text_widget.dart';
import 'package:mp3_music_converter/widgets/slider_widget.dart';
import 'package:mp3_music_converter/widgets/icon_button.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/widgets/image_widget.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';

class BottomPlayingIndicator extends StatefulWidget {
  BottomPlayingIndicator({this.slide});

  Widget slide;

  @override
  _BottomPlayingIndicatorState createState() => _BottomPlayingIndicatorState();
}

class _BottomPlayingIndicatorState extends State<BottomPlayingIndicator> {
  IconData playBtn = Icons.play_circle_outline;

  int index;

  IconData _iconData = Icons.play_circle_outline;

  bool playing = false;

  AudioPlayer _player;

  AudioCache cache;

  String mp3 = '';

  Log _log;
  String file_name, file_path, image, file;

  Duration position = new Duration();

  Duration musicLength = new Duration();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _player = AudioPlayer();
    cache = AudioCache(fixedPlayer: _player);

    _player.durationHandler = (d) {
      setState(() {
        musicLength = d;
      });
    };

    _player.positionHandler = (p) {
      setState(() {
        position = p;
      });
    };

    // if (playing == true) {
    //   load();
    // }
  }

  // load() async {
  //   if (SongViewCLass().onSong() == true) {
  //     setState(() {
  //       file_name = SongViewCLass().filename;
  //       file_path = SongViewCLass().filepath;
  //       image = SongViewCLass().imageFile;
  //       file = SongViewCLass().tpFile;
  //     });
  //   }
  // }

  play() {
    AudioPlayer player = AudioPlayer();
    player.play(mp3);
  }

  Widget slider() {
    return Slider.adaptive(
        inactiveColor: AppColor.white,
        activeColor: AppColor.bottomRed,
        value: position.inSeconds.toDouble(),
        max: musicLength.inSeconds.toDouble(),
        onChanged: (value) {
          seekToSec(value.toInt());
        });
  }

  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    _player.seek(newPos);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            //margin: EdgeInsets.only(top: 50),
            decoration: BoxDecoration(color: Colors.black),
            child: ListTile(
              leading: SizedBox(height: 95, width: 75, child: ImageFile()),
              // title:
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextTitle(),
                  SliderClass(),
                ],
              ),
              trailing: IconButt(),
            ),
          ),
          Divider(color: AppColor.white, height: 0.1),
        ]);
  }
}
