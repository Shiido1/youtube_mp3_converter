import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mp3_music_converter/screens/playlist/play_list_screen.dart';
import 'package:mp3_music_converter/screens/song/songs_screen.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.asset(AppAssets.rect),
                  Column(
                    children: [
                      SizedBox(height: 65),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextViewWidget(
                              color: AppColor.white,
                              text: 'Library',
                              textSize: 22,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Montserrat'),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipOval(
                                child: Image.asset('assets/burna.png'),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: TextViewWidget(
                                      color: AppColor.white,
                                      text: 'Profile',
                                      textSize: 17,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Montserrat-Thin')),
                              SizedBox(
                                height: 100,
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 48.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PlaylistScreen()),
                          );
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(AppAssets.library),
                            SizedBox(
                              width: 35,
                            ),
                            TextViewWidget(
                              text: 'Playlists',
                              color: AppColor.white,
                              textSize: 22,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 10, 34, 10),
                      child: Divider(color: AppColor.white, height: 2),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 48.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SongClass()),
                          );
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(AppAssets.music),
                            SizedBox(
                              width: 35,
                            ),
                            TextViewWidget(
                              text: 'Songs',
                              color: AppColor.white,
                              textSize: 22,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 10, 34, 10),
                      child: Divider(color: AppColor.white, height: 2),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 49.0),
                      child: Row(
                        children: [
                          SvgPicture.asset(AppAssets.record),
                          SizedBox(
                            width: 35,
                          ),
                          TextViewWidget(
                            text: ' Recorded',
                            color: AppColor.white,
                            textSize: 22,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 10, 34, 10),
                      child: Divider(color: AppColor.white, height: 2),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 48.0),
                      child: Row(
                        children: [
                          SvgPicture.asset(AppAssets.split),
                          SizedBox(
                            width: 35,
                          ),
                          TextViewWidget(
                            text: 'Splitted',
                            color: AppColor.white,
                            textSize: 22,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 10, 34, 10),
                      child: Divider(color: AppColor.white, height: 2),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40, bottom: 10),
                      child: TextViewWidget(
                        text: 'Recently Added',
                        color: AppColor.white,
                        textSize: 28,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(AppAssets.image1),
                        Image.asset(AppAssets.image1)
                      ],
                    )
                  ]),
              SizedBox(
                height: 33,
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(color: AppColor.black),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(
                              AppAssets.image1,
                              height: 80,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextViewWidget(
                                  text: 'kofi',
                                  color: AppColor.white,
                                  textSize: 16,
                                ),
                                TextViewWidget(
                                  text: 'Came Up',
                                  color: AppColor.white,
                                  textSize: 20,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                SvgPicture.asset(AppAssets.line),
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            SvgPicture.asset(AppAssets.play,
                                height: 50, width: 80)
                          ],
                        ),
                      ),
                    ),
                    Divider(color: AppColor.white, height: 0.1),
                  ]),
            ],
          ),
        ),
      ),
    );
  }
}
