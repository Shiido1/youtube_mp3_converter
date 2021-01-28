import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mp3_music_converter/bottom_navigation/my_library.dart';
import 'package:mp3_music_converter/bottom_navigation/playlist.dart';
import 'package:mp3_music_converter/bottom_navigation/search.dart';
import 'package:mp3_music_converter/bottom_navigation/setting.dart';
import 'package:mp3_music_converter/screens/converter/converter_screen.dart';
import 'package:mp3_music_converter/screens/playlist/music_screen.dart';
import 'package:mp3_music_converter/screens/world_radio/world_radio_screen.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/bottom_playlist_indicator.dart';
import 'package:mp3_music_converter/widgets/red_background.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';

class DashBoard extends StatefulWidget {
  int index;

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
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
      backgroundColor: AppColor.background,
      body: Column(
        children: [
          RedBackground(),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(left: 16, right: 90),
            child: ListView(
              children: [

                InkWell(
                  onTap: () {
                    res1();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ConverterScreen()),
                    );
                  },
                  child: Container(
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
                              textSize: 18,
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MusicClass(
                                index: 0,
                              )),
                    );
                  },
                  child: Container(
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
                              textSize: 18,
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WorldRadioClass()),
                    );
                  },
                  child: Container(
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
                              textSize: 18,
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
                            color:
                                djRes != true ? AppColor.white : AppColor.black,
                            height: 24,
                            width: 25,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          TextViewWidget(
                            color:
                                djRes != true ? AppColor.white : AppColor.black,
                            text: 'Disk Jockey',
                            textSize: 18,
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
                            textSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
              ],
            ),
          )),
          BottomPlayingIndicator()
        ],
      ),
    );
  }
}
