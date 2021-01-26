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
  bool converterRes = false;
  bool musicRes = false;
  bool radioRes = false;
  bool djRes = false;
  bool planRes = false;

  bool res1() {
    if (converterRes == false) {
      setState(() {
        converterRes = true;
        musicRes = false;
        radioRes = false;
        djRes = false;
        planRes = false;
      });
      return false;
    } else if (converterRes == true) {
      setState(() {
        converterRes = false;
      });
    }
    return converterRes;
  }

  bool res2() {
    if (musicRes == false) {
      setState(() {
        musicRes = true;
        converterRes = false;
        radioRes = false;
        djRes = false;
        planRes = false;
      });
      return false;
    } else if (musicRes == true) {
      setState(() {
        musicRes = false;
      });
    }
    return musicRes;
  }

  bool res3() {
    if (radioRes == false) {
      setState(() {
        radioRes = true;
        musicRes = false;
        converterRes = false;
        djRes = false;
        planRes = false;
      });
      return false;
    } else if (radioRes == true) {
      setState(() {
        radioRes = false;
      });
    }
    return radioRes;
  }

  bool res4() {
    if (djRes == false) {
      setState(() {
        djRes = true;
        musicRes = false;
        radioRes = false;
        converterRes = false;
        planRes = false;
      });
      return false;
    } else if (djRes == true) {
      setState(() {
        djRes = false;
      });
    }
    return djRes;
  }

  bool res5() {
    if (planRes == false) {
      setState(() {
        planRes = true;
        musicRes = false;
        radioRes = false;
        djRes = false;
        converterRes = false;
      });
      return false;
    } else if (planRes == true) {
      setState(() {
        planRes = false;
      });
    }
    return planRes;
  }

  List<Widget> _screens = [PlayList(), Library(), Search(), Setting()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColor.background,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(children: [
                Stack(
                  children: [
                    Image.asset('assets/rect.png'),
                    Column(
                      children: [
                        SizedBox(height: 45),
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
                      ],
                    ),
                  ],
                ),
              ]),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      res1();
                    },
                    child: Container(
                        margin: converterRes != true
                            ? EdgeInsets.only(right: 120)
                            : EdgeInsets.only(right: 90),
                        decoration: BoxDecoration(
                            color: converterRes != true
                                ? AppColor.transparent
                                : Colors.redAccent[100].withOpacity(0.8),
                            border: Border.all(
                              color: converterRes != true
                                  ? AppColor.white
                                  : Colors.redAccent[100].withOpacity(0.8),
                            ),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/svg/mp_file.svg',
                                color: converterRes != true
                                    ? AppColor.white
                                    : AppColor.black,
                                height: 24,
                                width: 25,
                              ),
                              SizedBox(width: 10),
                              TextViewWidget(
                                color: converterRes != true
                                    ? AppColor.white
                                    : AppColor.black,
                                text: 'Converter',
                                textSize: 22,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Montserrat',
                              ),
                            ],
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      res2();
                    },
                    child: Container(
                      margin: musicRes != true
                          ? EdgeInsets.only(right: 120)
                          : EdgeInsets.only(right: 90),
                      decoration: BoxDecoration(
                          // color: Colors.redAccent[100].withOpacity(0.8),
                          color: musicRes != true
                              ? AppColor.transparent
                              : Colors.redAccent[100].withOpacity(0.8),
                          border: Border.all(
                            color: musicRes != true
                                ? AppColor.white
                                : Colors.redAccent[100].withOpacity(0.8),
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
                              color: musicRes != true
                                  ? AppColor.white
                                  : AppColor.black,
                              height: 24,
                              width: 25,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextViewWidget(
                                color: musicRes != true
                                    ? AppColor.white
                                    : AppColor.black,
                                text: 'Create your Music',
                                textSize: 22,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Montserrat',
                                // onTapCallBack: () => res(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      res3();
                    },
                    child: Container(
                      margin: radioRes != true
                          ? EdgeInsets.only(right: 120)
                          : EdgeInsets.only(right: 90),
                      decoration: BoxDecoration(
                          color: radioRes != true
                              ? AppColor.transparent
                              : Colors.redAccent[100].withOpacity(0.8),
                          border: Border.all(
                            color: radioRes != true
                                ? AppColor.white
                                : Colors.redAccent[100].withOpacity(0.8),
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
                              color: radioRes != true
                                  ? AppColor.white
                                  : AppColor.black,
                              height: 24,
                              width: 25,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextViewWidget(
                                color: radioRes != true
                                    ? AppColor.white
                                    : AppColor.black,
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
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      res4();
                    },
                    child: Container(
                      margin: djRes != true
                          ? EdgeInsets.only(right: 120)
                          : EdgeInsets.only(right: 90),
                      decoration: BoxDecoration(
                          color: djRes != true
                              ? AppColor.transparent
                              : Colors.redAccent[100].withOpacity(0.8),
                          border: Border.all(
                            color: djRes != true
                                ? AppColor.white
                                : Colors.redAccent[100].withOpacity(0.8),
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
                              color: djRes != true
                                  ? AppColor.white
                                  : AppColor.black,
                              height: 24,
                              width: 25,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            TextViewWidget(
                              color: djRes != true
                                  ? AppColor.white
                                  : AppColor.black,
                              text: 'Disk Jockey',
                              textSize: 22,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Montserrat',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () => res5(),
                    child: Container(
                      margin: planRes != true
                          ? EdgeInsets.only(right: 120)
                          : EdgeInsets.only(right: 90),
                      decoration: BoxDecoration(
                          color: planRes != true
                              ? AppColor.transparent
                              : Colors.redAccent[100].withOpacity(0.8),
                          border: Border.all(
                            color: planRes != true
                                ? AppColor.white
                                : Colors.redAccent[100].withOpacity(0.8),
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
                              color: planRes != true
                                  ? AppColor.white
                                  : AppColor.black,
                              height: 24,
                              width: 25,
                            ),
                            SizedBox(width: 10),
                            TextViewWidget(
                              fontFamily: 'Montserrat',
                              color: planRes != true
                                  ? AppColor.white
                                  : AppColor.black,
                              text: 'Plan',
                              textSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(color: Colors.black),
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
                ],
              ),
            ],
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
    );
  }
}

//  class CurvePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     var paint = Paint();
//     paint.color = AppColor.red;
//     paint.style = PaintingStyle.fill; // Change this to fill

//     var path = Path();

//     path.moveTo(0, size.height * 0.25);
//     path.quadraticBezierTo(
//         size.width / 2, size.height / 2, size.width, size.height * 0.25);
//     path.lineTo(size.width, 0);
//     path.lineTo(0, 0);

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }
