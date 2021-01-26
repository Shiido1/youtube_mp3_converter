import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';

class WorldRadioClass extends StatefulWidget {
  @override
  _WorldRadioClassState createState() => _WorldRadioClassState();
}

class _WorldRadioClassState extends State<WorldRadioClass>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColor.background1,
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset('assets/rect.png'),
                Column(
                  children: [
                    SizedBox(height: 65),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextViewWidget(
                            color: AppColor.white,
                            text: 'Radio World Wide',
                            textSize: 20,
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
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Montserrat-Thin'),
                            ),
                            SizedBox(
                              height: 168,
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Center(
              child: AnimatedBuilder(
                  animation: _controller,
                  builder: (_, child) {
                    return Transform.rotate(
                      angle: _controller.value * 2 * 3.145,
                      child: child,
                    );
                  },
                  child: Image.asset(
                    AppAssets.globe,
                    height: 350,
                    width: 350,
                  )),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: Colors.grey[900]),
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextViewWidget(
                              text: 'Cool FM 96.9',
                              color: Colors.white,
                              textSize: 20,
                              fontWeight: FontWeight.bold),
                          TextViewWidget(
                            text: 'Lagos',
                            color: Colors.white,
                            textSize: 18,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SvgPicture.asset(AppAssets.previous,
                          height: 30, width: 30),
                      SvgPicture.asset(AppAssets.play, height: 45, width: 45),
                      SvgPicture.asset(AppAssets.next, height: 30, width: 30),
                      SizedBox(
                        width: 20,
                      ),
                      SvgPicture.asset(AppAssets.favorite,
                          height: 30, width: 30),
                    ],
                  ),
                ),
              ),
            ),
            Divider(color: Colors.white, height: 0.1),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        backgroundColor: Colors.grey[900],
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
            label: 'My Library',
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
