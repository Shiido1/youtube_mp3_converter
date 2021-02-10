import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mp3_music_converter/bottom_navigation/playlist.dart';
import 'package:mp3_music_converter/screens/playlist/music_screen.dart';
import 'package:mp3_music_converter/screens/playlist/play_list_screen.dart';
import 'package:mp3_music_converter/screens/playlist/test_container.dart';
import 'package:mp3_music_converter/screens/recorded/recorded.dart';
import 'package:mp3_music_converter/screens/recorded/recorded_class.dart';
import 'package:mp3_music_converter/screens/song/songs_screen.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/bottom_playlist_indicator.dart';
import 'package:mp3_music_converter/widgets/red_background.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';

class Library extends StatefulWidget {
  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: AppColor.background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RedBackground(
              text: 'Library',
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 16, right: 16),
                child: ListView(children: [
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MusicClass(index: 1),
                          ));
                    },
                    leading: SvgPicture.asset(AppAssets.library),
                    title: TextViewWidget(
                      text: 'Playlists',
                      color: AppColor.white,
                      textSize: 18,
                    ),
                  ),
                  Divider(
                    color: AppColor.white,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SongClass()),
                      );
                    },
                    leading: SvgPicture.asset(AppAssets.music),
                    title: TextViewWidget(
                      text: 'Songs',
                      color: AppColor.white,
                      textSize: 18,
                    ),
                  ),
                  Divider(
                    color: AppColor.white,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RecordedClass()),
                      );
                    },
                    leading: SvgPicture.asset(AppAssets.record),
                    title: TextViewWidget(
                      text: 'Recorded',
                      color: AppColor.white,
                      textSize: 18,
                    ),
                  ),
                  Divider(
                    color: AppColor.white,
                  ),
                  ListTile(
                    onTap: () {},
                    leading: SvgPicture.asset(AppAssets.split),
                    title: TextViewWidget(
                      text: 'Splitted',
                      color: AppColor.white,
                      textSize: 18,
                    ),
                  ),
                  Divider(
                    color: AppColor.white,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextViewWidget(
                    text: 'Recently Added',
                    color: AppColor.white,
                    textSize: 20,
                    fontFamily: 'Montserrat',
                  ),
                  Container(
                    height: 100,
                    margin: EdgeInsets.only(top: 10),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [1, 2, 3, 4, 5]
                          .map((e) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(AppAssets.image1),
                              ))
                          .toList(),
                    ),
                  )
                ]),
              ),
            ),
            BottomPlayingIndicator(),
          ],
        ),
      ),
    );
  }
}