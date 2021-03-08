import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';

class SliderClass extends StatefulWidget {
  @override
  _SliderClassState createState() => _SliderClassState();
}

class _SliderClassState extends State<SliderClass> {
  AudioPlayer _player;
  AudioCache cache;

  Duration position = new Duration();
  Duration musicLength = new Duration();

  bool isPlay;
  String mp3 = '';

  // load() async {
  //   if (SongViewCLass().onSong() == true) {
  //     setState(() {
  //       file_name = SongViewCLass().filename;
  //       file_path = SongViewCLass().filepath;
  //       image = SongViewCLass().imageFile;
  //       file = SongViewCLass().tpFile;
  //     });
  //     File tpFile = File('$file_path/$file_name');
  //     mp3 = tpFile.uri.toString();
  //   }
  // }

  // play() async {
  //   AudioPlayer player = AudioPlayer();
  //   player.play(mp3);
  // }

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    cache = AudioCache(fixedPlayer: _player);
    prefMed();
    // _player.play(mp3);

    preferencesHelper
        .getIntValues(key: 'position')
        .then((value) => setState(() {
              position = pos(value.toString());
            }));

    preferencesHelper
        .getIntValues(key: 'mus_length')
        .then((value) => setState(() {
              musicLength = pos(value.toString());
            }));

    _player.durationHandler = (d) {
      setState(() {
        musicLength = musicLength;
      });
    };

    _player.positionHandler = (p) {
      setState(() {
        position = position;
      });
    };
  }

  Duration pos(String val) {
    int sec = 0;
    int minutes = 0;
    List<String> parts = val.split(':');

    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    sec = (double.parse(parts[parts.length - 1]) * 1000000).round();
    return Duration(minutes: minutes, microseconds: sec);
  }

  Widget slider() {
    return Container(
      // width: 300.0,
      child: Slider.adaptive(
          inactiveColor: AppColor.white,
          activeColor: AppColor.bottomRed,
          value: position.inSeconds.toDouble(),
          max: musicLength.inSeconds.toDouble(),
          onChanged: (value) {
            seekToSec(value.toInt());
          }),
    );
  }

  void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    _player.seek(newPos);
  }

  prefMed() {
    preferencesHelper.getStringValues(key: 'mp3').then((value) => setState(() {
          mp3 = value;
        }));
    preferencesHelper.getBoolValues(key: 'true').then((value) => setState(() {
          isPlay = value;
        }));
  }

  // Widget dur() {
  //   _player.onDurationChanged.listen((Duration d) {
  //   print('Max duration: $d');
  //   setState(() => musicLength = d);
  // });
  //   return Text(
  //     '$musicLength',
  //     style: TextStyle(
  //         fontSize: 12, color: AppColor.white),
  //   );
  // }

  // Widget pos() {
  //   _player.onAudioPositionChanged.listen((Duration  p) {
  //   print('Current position: $p');
  //   setState(() => position = p);
  // });
  //   return Text(
  //     '$position',
  //     style: TextStyle(
  //         fontSize: 12, color: AppColor.white),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // prefMed();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextViewWidget(
          text: "${position.inMinutes}:${position.inSeconds.remainder(60)}",
          color: AppColor.white,
        ),
        Expanded(flex: 8, child: slider()),
        TextViewWidget(
          text:
              "${musicLength.inMinutes}:${musicLength.inSeconds.remainder(60)}",
          color: AppColor.white,
        ),
      ],
    );
  }
}
