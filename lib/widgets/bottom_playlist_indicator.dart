import 'package:mp3_music_converter/widgets/app_text_widget.dart';
import 'package:mp3_music_converter/widgets/slider2_widget.dart';
import 'package:mp3_music_converter/widgets/icon_button.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/widgets/image_widget.dart';
import 'package:mp3_music_converter/screens/song/song_view_screen.dart';
import 'package:mp3_music_converter/utils/page_router/navigator.dart';
import 'package:mp3_music_converter/screens/song/provider/music_provider.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';

import 'package:provider/provider.dart';

class BottomPlayingIndicator extends StatefulWidget {
  @override
  _BottomPlayingIndicatorState createState() => _BottomPlayingIndicatorState();
}

class _BottomPlayingIndicatorState extends State<BottomPlayingIndicator> {
  String mp3 = '';
  String file_name, image, file;
  MusicProvider _musicProvider;

  @override
  void initState() {
    _musicProvider = Provider.of<MusicProvider>(context, listen: false);
    prefMed();
    super.initState();
  }

  prefMed() {
    preferencesHelper
        .getStringValues(key: 'image')
        .then((value) => setState(() {
              image = value;
            }));

    preferencesHelper
        .getStringValues(key: 'filename')
        .then((value) => setState(() {
              file_name = value;
            }));

    preferencesHelper.getStringValues(key: 'mp3').then((value) => setState(() {
          file = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => PageRouter.gotoWidget(
                SongViewScreen(
                    _musicProvider.musicdata.image,
                    _musicProvider.musicdata.fileName,
                    _musicProvider.musicdata.file),
                context),
            child: Container(
              decoration: BoxDecoration(color: AppColor.black),
              child: Row(children: [
                SizedBox(height: 75, width: 75, child: ImageFile()),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextTitle(),
                      SliderClass2(),
                    ],
                  ),
                ),
                Column(
                  children: [
                    IconButt(),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
                SizedBox(
                  width: 20,
                )
              ]),
            ),
          ),
          Divider(color: AppColor.white, height: 0.1),
        ]);
  }
}
