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
  TextStyle textStyle =
      TextStyle(color: AppColor.white, fontSize: 14, fontFamily: 'Roboto');

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

  bool hasOverflow(String text, TextStyle style, {double maxWidth}) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: maxWidth);
    return textPainter.didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    // prefMed();
    return LayoutBuilder(builder: (context, constraint) {
      String text = _musicProvider?.currentSong?.fileName ?? '';
      return text.isNotEmpty ?? false
          ? Container(
              height: 20,
              width: constraint.maxWidth,
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: hasOverflow(text, textStyle, maxWidth: constraint.maxWidth)
                  ? Marquee(
                      text: text,
                      scrollAxis: Axis.horizontal,
                      blankSpace: 30,
                      startAfter: Duration(seconds: 2),
                      pauseAfterRound: Duration(seconds: 1),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      style: textStyle,
                    )
                  : Text(
                      text,
                      style: textStyle,
                    ),
            )
          : Container();
    });
  }
}
