import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:marquee/marquee.dart';
import 'package:mp3_music_converter/screens/recorded/provider/record_provider.dart';
import 'package:mp3_music_converter/widgets/app_text_widget.dart';
import 'package:mp3_music_converter/widgets/slider2_widget.dart';
import 'package:mp3_music_converter/widgets/icon_button.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/widgets/image_widget.dart';
import 'package:mp3_music_converter/screens/song/song_view_screen.dart';
import 'package:mp3_music_converter/screens/song/provider/music_provider.dart';

import 'package:provider/provider.dart';

class BottomPlayingIndicator extends StatefulWidget {
  final bool isMusic;
  final bool enabled;

  BottomPlayingIndicator({this.isMusic = true, this.enabled = false});

  @override
  _BottomPlayingIndicatorState createState() => _BottomPlayingIndicatorState();
}

class _BottomPlayingIndicatorState extends State<BottomPlayingIndicator> {
  MusicProvider _musicProvider;
  TextStyle textStyle =
      TextStyle(color: AppColor.white, fontSize: 14, fontFamily: 'Roboto');

  bool hasOverflow(String text, TextStyle style, {double maxWidth}) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: maxWidth);
    return textPainter.didExceedMaxLines;
  }

  @override
  void initState() {
    _musicProvider = Provider.of<MusicProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isMusic)
      return Consumer<MusicProvider>(
        builder: (_, _provider, __) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  int width = MediaQuery.of(context).size.width.floor();
                  if (_provider.currentSong != null)
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) =>
                            SongViewScreen(_musicProvider.currentSong, width),
                      ),
                    );
                },
                child: Container(
                  decoration: BoxDecoration(color: AppColor.black),
                  child: Row(
                    children: [
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
                    ],
                  ),
                ),
              ),
              Divider(color: AppColor.white, height: 0.1),
            ],
          );
        },
      );
    else
      return Consumer<RecordProvider>(
        builder: (_, _provider, __) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(color: AppColor.black),
                child: Row(children: [
                  SizedBox(
                    height: 75,
                    width: 75,
                    child: Image.asset('assets/log.png'),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: LayoutBuilder(builder: (context, viewport) {
                        String text = _provider?.currentRecord?.name ?? '';
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // if (_provider.equalizer)
                            Container(
                              height: 20,
                              width: viewport.maxWidth,
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: hasOverflow(text, textStyle,
                                      maxWidth: viewport.maxWidth)
                                  ? Marquee(
                                      text: text,
                                      scrollAxis: Axis.horizontal,
                                      blankSpace: 30,
                                      startAfter: Duration(seconds: 2),
                                      pauseAfterRound: Duration(seconds: 2),
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      style: textStyle,
                                    )
                                  : Text(
                                      text,
                                      style: textStyle,
                                    ),
                            ),
                            SliderClass3(),
                          ],
                        );
                      }),
                    ),
                  ),
                  Column(
                    children: [
                      IconButt2(widget.enabled),
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
              Divider(color: AppColor.white, height: 0.1),
            ],
          );
        },
      );
  }
}
