import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:mp3_music_converter/database/model/log.dart';
import 'package:mp3_music_converter/database/repository/log_repository.dart';
import 'package:mp3_music_converter/screens/song/song_view.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';

class TextTitle extends StatefulWidget {
  @override
  _TextTitleState createState() => _TextTitleState();
}

class _TextTitleState extends State<TextTitle> {
  String filename;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    prefMed();
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
    prefMed();
    return filename != null && filename.isNotEmpty
        ? Container(
            height: 20,
            child: Marquee(
              text: filename,
              scrollAxis: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              style: TextStyle(
                  color: AppColor.white, fontSize: 14, fontFamily: 'Roboto'),
            ))
        : Container();
  }
}
