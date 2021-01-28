import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';

class PlaylistScreen extends StatefulWidget {
  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.black,
        title: TextViewWidget(
          text: 'Playlist',
          color: AppColor.bottomRed,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: AppColor.bottomRed,
          ),
        ),
      ),
      body: Center(
        child: ListView(children: [
          Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Image.asset(
                'assets/mqdefault4.png',
                height: 250,
                width: 250,
              ),
              SizedBox(
                height: 15,
              ),
              TextViewWidget(
                text: "Untitled Playlist",
                color: AppColor.white,
                textSize: 22,
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        SvgPicture.asset(AppAssets.favorite),
                        TextViewWidget(text: 'Favorite', color: AppColor.white)
                      ],
                    ),
                    Column(
                      children: [
                        SvgPicture.asset(AppAssets.shuffle),
                        TextViewWidget(text: 'Shuffle', color: AppColor.white)
                      ],
                    ),
                    Column(
                      children: [
                        SvgPicture.asset(AppAssets.repeat),
                        TextViewWidget(text: 'Repeat', color: AppColor.white)
                      ],
                    ),
                    Column(
                      children: [
                        SvgPicture.asset(AppAssets.share),
                        TextViewWidget(text: 'Share', color: AppColor.white)
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButton(
                      color: AppColor.fadedPink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      onPressed: () {},
                      child: TextViewWidget(
                        color: AppColor.white,
                        text: 'Play',
                        textSize: 18.5,
                      )),
                  FlatButton(
                      color: AppColor.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      onPressed: () {},
                      child: TextViewWidget(
                        color: AppColor.white,
                        text: 'Shuffle',
                        textSize: 18.5,
                      ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 30, top: 16.0, bottom: 16.0, left: 30),
                child: Divider(color: AppColor.white, height: 0.1),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      AppAssets.image1,
                      height: 70,
                      width: 70,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextViewWidget(
                          text: 'Something Fishy',
                          color: AppColor.white,
                          textSize: 22,
                        ),
                        TextViewWidget(
                          text: 'davido',
                          color: AppColor.white,
                          textSize: 16,
                        )
                      ],
                    ),
                    SvgPicture.asset(
                      AppAssets.dot,
                      color: AppColor.white,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 30, top: 16.0, bottom: 16.0, left: 30),
                child: Divider(color: AppColor.white, height: 0.1),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      AppAssets.image1,
                      height: 70,
                      width: 70,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextViewWidget(
                          text: 'Something Fishy',
                          color: AppColor.white,
                          textSize: 22,
                        ),
                        TextViewWidget(
                          text: 'davido',
                          color: AppColor.white,
                          textSize: 16,
                        )
                      ],
                    ),
                    SvgPicture.asset(
                      AppAssets.dot,
                      color: AppColor.white,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
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
                    SvgPicture.asset(AppAssets.play, height: 50, width: 80)
                  ],
                ),
              ),
            ),
            Divider(color: AppColor.white, height: 0.1),
          ]),
        ]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        backgroundColor: AppColor.black,
        selectedItemColor: AppColor.bottomRed,
        unselectedItemColor: AppColor.white,
        selectedLabelStyle: Theme.of(context).textTheme.caption,
        elevation: 5,
        unselectedLabelStyle: Theme.of(context).textTheme.caption,
        unselectedFontSize: 30,
        onTap: (value) {
          setState(() => _currentIndex = value);
        },
        items: [
          BottomNavigationBarItem(
            label: 'Playlist',
            icon: SvgPicture.asset(
              AppAssets.library,
              color: _currentIndex == 0 ? AppColor.bottomRed : AppColor.white,
            ),
          ),
          BottomNavigationBarItem(
            label: 'My Library',
            icon: SvgPicture.asset(
              AppAssets.playlist,
              color: _currentIndex == 1 ? AppColor.bottomRed : AppColor.white,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Search',
            icon: SvgPicture.asset(
              AppAssets.search,
              color: _currentIndex == 2 ? AppColor.bottomRed : AppColor.white,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Setting',
            icon: SvgPicture.asset(
              AppAssets.setting,
              color: _currentIndex == 3 ? AppColor.bottomRed : AppColor.white,
            ),
          ),
        ],
      ),
    );
  }
}
