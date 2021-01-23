import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mp3_music_converter/bottom_navigation/my_library.dart';
import 'package:mp3_music_converter/bottom_navigation/playlist.dart';
import 'package:mp3_music_converter/bottom_navigation/search.dart';
import 'package:mp3_music_converter/bottom_navigation/setting.dart';
import 'package:mp3_music_converter/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int _currentIndex = 0;

  List<Widget> _screens = [PlayList(), Library(), Search(), Setting()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.grey[850],
        // decoration: new BoxDecoration(
        //   color: Colors.grey[850],
        //   image: new DecorationImage(
        //     fit: BoxFit.cover,
        //     colorFilter: new ColorFilter.mode(
        //         Colors.black.withOpacity(0.5), BlendMode.dstATop),
        //     image: new AssetImage(
        //       AppAssets.bgImage2,
        //     ),
        //   ),
        // ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.red,
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(AppAssets.logo),
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
                        child: Text(
                          'Profile',
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Montserrat-Thin'),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
                margin: EdgeInsets.only(right: 90),
                decoration: BoxDecoration(
                    color: Colors.redAccent[100].withOpacity(0.8),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/svg/mp_file.svg',
                        color: Colors.black,
                        height: 24,
                        width: 25,
                      ),
                      SizedBox(width: 10),
                      TextViewWidget(
                        color: Colors.black,
                        text: 'Converter',
                        textSize: 22,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Montserrat',
                      ),
                    ],
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(right: 120),
              decoration: BoxDecoration(
                  // color: Colors.redAccent[100].withOpacity(0.8),
                  border: Border.all(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: Padding(
                padding: const EdgeInsets.all(13),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/svg/radio_wave.svg',
                      color: Colors.white,
                      height: 24,
                      width: 25,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextViewWidget(
                        color: Colors.white,
                        text: 'Create your Music',
                        textSize: 22,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(right: 120),
              decoration: BoxDecoration(
                  // color: Colors.redAccent[100].withOpacity(0.8),
                  border: Border.all(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: Padding(
                padding: const EdgeInsets.all(13),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/svg/radio.svg',
                      color: Colors.white,
                      height: 24,
                      width: 25,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextViewWidget(
                        color: Colors.white,
                        text: 'Radio World Wide',
                        textSize: 22,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(right: 120),
              decoration: BoxDecoration(
                  // color: Colors.redAccent[100].withOpacity(0.8),
                  border: Border.all(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: Padding(
                padding: const EdgeInsets.all(13),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/svg/dj_mixer.svg',
                      color: Colors.white,
                      height: 24,
                      width: 25,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    TextViewWidget(
                      color: Colors.white,
                      text: 'Disk Jockey',
                      textSize: 22,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Montserrat',
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(right: 120),
              decoration: BoxDecoration(
                  // color: Colors.redAccent[100].withOpacity(0.8),
                  border: Border.all(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: Padding(
                padding: const EdgeInsets.all(13),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/svg/plan.svg',
                      color: Colors.white,
                      height: 24,
                      width: 25,
                    ),
                    SizedBox(width: 10),
                    TextViewWidget(
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                      text: 'Plan',
                      textSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 50),
            Container(
              decoration: BoxDecoration(color: Colors.black),
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 10, bottom: 10),
                child: Row(
                  children: [Image.asset(AppAssets.image1, height: 85)],
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: Colors.white,
                height: 6,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
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
              // color: _currentIndex == 0 ? AppColor.blue : AppColor.grey,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Library',
            icon: SvgPicture.asset(
              AppAssets.playlist,
              // color: _currentIndex == 1 ? AppColor.blue : AppColor.grey,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Search',
            icon: SvgPicture.asset(
              AppAssets.search,
              // color: _currentIndex == 2 ? AppColor.blue : AppColor.grey,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Setting',
            icon: SvgPicture.asset(
              AppAssets.setting,
              // color: _currentIndex == 3 ? AppColor.blue : AppColor.grey,
            ),
          ),
        ],
      ),
    );
  }
}
