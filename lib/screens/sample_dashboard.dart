import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mp3_music_converter/bottom_navigation/my_library.dart';
import 'package:mp3_music_converter/bottom_navigation/playlist.dart';
import 'package:mp3_music_converter/bottom_navigation/search.dart';
import 'package:mp3_music_converter/bottom_navigation/setting.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';

class Sample extends StatefulWidget {
  @override
  _SampleState createState() => _SampleState();
}

class _SampleState extends State<Sample> {
  int _currentIndex = 0;

  List<Widget> _screens = [PlayList(), Library(), Search(), Setting()];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drawing Paths',
      home: Scaffold(
        body: Container(
          color: AppColor.background,
          child: CustomPaint(
            painter: CurvePainter(),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                  color: AppColor.white,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Montserrat-Thin'),
                            ),
                          ),
                          SizedBox(
                            height: 160,
                          ),
                        ],
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
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
                                  color: AppColor.black,
                                  height: 24,
                                  width: 25,
                                ),
                                SizedBox(width: 10),
                                TextViewWidget(
                                  color: AppColor.black,
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
                              color: AppColor.white,
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
                                color: AppColor.white,
                                height: 24,
                                width: 25,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: TextViewWidget(
                                  color: AppColor.white,
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
                              color: AppColor.white,
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
                                color: AppColor.white,
                                height: 24,
                                width: 25,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: TextViewWidget(
                                  color: AppColor.white,
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
                              color: AppColor.white,
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
                                color: AppColor.white,
                                height: 24,
                                width: 25,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              TextViewWidget(
                                color: AppColor.white,
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
                              color: AppColor.white,
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
                                color: AppColor.white,
                                height: 24,
                                width: 25,
                              ),
                              SizedBox(width: 10),
                              TextViewWidget(
                                fontFamily: 'Montserrat',
                                color: AppColor.white,
                                text: 'Plan',
                                textSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Container(
                        decoration: BoxDecoration(color: Colors.black),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, top: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(
                                AppAssets.image1,
                                height: 100,
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
                                  SvgPicture.asset('assets/svg/line.svg'),
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              SvgPicture.asset('assets/svg/play-icon.svg',
                                  height: 50, width: 80)
                            ],
                          ),
                        ),
                      ),
                      Divider(color: AppColor.white, height: 0.1),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          backgroundColor: AppColor.black,
          selectedItemColor: AppColor.white,
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
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = AppColor.red;
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height * 0.25);
    path.quadraticBezierTo(
        size.width / 2, size.height / 2, size.width, size.height * 0.25);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
