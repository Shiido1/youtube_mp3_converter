import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';

class PlayList extends StatefulWidget {
  @override
  _PlayListState createState() => _PlayListState();
}

class _PlayListState extends State<PlayList> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColor.background,
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
                            text: 'Playlist',
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
                              height: 150,
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
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      color: AppColor.background1,
                      height: 85,
                      width: 85,
                      child: Icon(
                        Icons.add,
                        size: 50,
                      ),
                    ),
                    TextViewWidget(
                      text: 'New Playlists',
                      color: AppColor.white,
                      textSize: 22,
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward_ios_outlined),
                      onPressed: () {},
                      color: AppColor.white,
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(110, 10, 34, 10),
                  child: Divider(color: AppColor.white, height: 2),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Container()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 7, right: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          AppAssets.image1,
                          height: 80,
                        ),
                        TextViewWidget(
                          text: 'Untitled Playlists',
                          color: AppColor.white,
                          textSize: 22,
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_forward_ios_outlined),
                          onPressed: () {},
                          color: AppColor.white,
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(110, 10, 34, 10),
                  child: Divider(color: AppColor.white, height: 2),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Container()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 7, right: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          AppAssets.image1,
                          height: 80,
                        ),
                        TextViewWidget(
                          text: 'Untitled Playlists',
                          color: AppColor.white,
                          textSize: 22,
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_forward_ios_outlined),
                          onPressed: () {},
                          color: AppColor.white,
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(110, 10, 34, 10),
                  child: Divider(color: AppColor.white, height: 2),
                ),
              ],
            ),
            Expanded(
              child: SizedBox(
                height: 6.5,
              ),
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
          ],
        ),
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
