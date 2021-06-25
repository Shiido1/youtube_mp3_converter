import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:mp3_music_converter/screens/song/provider/music_provider.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:provider/provider.dart';

class TextTitle extends StatefulWidget {
  @override
  _TextTitleState createState() => _TextTitleState();
}

class _TextTitleState extends State<TextTitle> {
  String filename;
  MusicProvider _musicProvider;

  @override
  void initState() {
    super.initState();
    _musicProvider = Provider.of<MusicProvider>(context, listen: false);
  }

  prefMed() {
    preferencesHelper
        .getStringValues(key: 'filename')
        .then((value) => setState(() {
              filename = value;
            }));
  }

  @override
  Widget build(BuildContext context) {
    // prefMed();
    return _musicProvider?.currentSong?.fileName?.isNotEmpty ?? false
        ? Container(
            height: 20,
            child: Marquee(
              text: _musicProvider?.currentSong?.fileName ?? '',
              scrollAxis: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              style: TextStyle(
                  color: AppColor.white, fontSize: 14, fontFamily: 'Roboto'),
            ))
        : Container();
  }
}
