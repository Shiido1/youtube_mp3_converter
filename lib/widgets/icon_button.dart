import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';

class IconButt extends StatefulWidget {
  @override
  _IconButtState createState() => _IconButtState();
}

class _IconButtState extends State<IconButt> {
  IconData _iconData = Icons.play_circle_outline;
  bool playing = false;
  String image;
  String file;
  bool isPlay = false;

  AudioPlayer _player;
  AudioCache cache;
  String mp3 = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _player = AudioPlayer();
    cache = AudioCache(fixedPlayer: _player);
    init();
  }

  init() {
    if (prefMed() == true) {
      prefMed();
      setState(() {
        // ignore: unnecessary_statements
        prefMed() == false;
        preferencesHelper
            .getBoolValues(key: 'prefMed')
            .then((value) => setState(() {}));
      });
    } else {
      return null;
    }
  }

  bool prefMed() {
    preferencesHelper.getStringValues(key: 'mp3').then((value) => setState(() {
          mp3 = value;
        }));
    if (mp3.isNotEmpty && mp3 != null && !playing) {
      preferencesHelper.getBoolValues(key: 'true').then((value) => setState(() {
            _iconData = Icons.pause_circle_outline;
            // playing = true;
          }));
    } else {
      setState(() {
        _iconData = Icons.play_circle_outline;
        // playing = false;
      });
    }
    preferencesHelper.saveValue(key: 'prefMed', value: true);
    return false;
  }

  playMeds() async {
    // _player.play(mp3);
    // if (mp3.isEmpty && mp3 == null) {
    //   setState(() {
    //     _iconData = Icons.play_circle_outline;
    //   });
    // preferencesHelper
    //     .getStringValues(key: 'mp3')
    //     .then((value) => setState(() {
    //           mp3 = value;
    //         }));
    // return null;
    // }
    if (mp3.isNotEmpty && mp3 != null && !playing) {
      await _player.play(mp3);

      preferencesHelper.getBoolValues(key: 'true').then((value) => setState(() {
            _iconData = Icons.pause_circle_outline;
            playing = true;
          }));
    } else {
      setState(() {
        _iconData = Icons.play_circle_outline;
        playing = false;
      });

      await _player.pause();
    }
  }

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
  //   _player.play(mp3);
  // }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        iconSize: 50,
        color: AppColor.white,
        icon: Icon(_iconData),
        onPressed: () {
          // prefMed();
          playMeds();
          // _player.play(mp3);
          // if (!playing) {
          //   preferencesHelper
          //       .getBoolValues(key: 'true')
          //       .then((value) => setState(() {
          //             isPlay = value;
          //           }));
          //   setState(() {
          //     if (isPlay = false) {
          //       _iconData = Icons.pause_circle_outline;
          //     }
          //     // playing = true;
          //   });
          // } else {
          //   preferencesHelper
          //       .getBoolValues(key: 'false')
          //       .then((value) => setState(() {
          //             isPlay = false;
          //           }));
          //   setState(() {
          //     if (isPlay = true) {
          //       _iconData = Icons.play_circle_outline;
          //     }
          //     // playing = false;
          //   });
        });
  }
}
