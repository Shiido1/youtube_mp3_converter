import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mp3_music_converter/screens/converter/convert.dart';
import 'package:mp3_music_converter/screens/playlist/music_screen.dart';
import 'package:mp3_music_converter/screens/world_radio/radio_class.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/bottom_playlist_indicator.dart';
import 'package:mp3_music_converter/widgets/red_background.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';

// ignore: must_be_immutable
class DashBoard extends StatefulWidget {
  int index;

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  HomeButtonItem _homeButtonItem = HomeButtonItem.NON;

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
                _buttonItem(
                  title: "Converter",
                  item: HomeButtonItem.CONVERTER,
                  screen: Convert(),
                  assets: AppAssets.mpFile,
                ),
                SizedBox(
                  height: 20,
                ),
                _buttonItem(
                  title: "Create your Music",
                  item: HomeButtonItem.CREATE_MUSIC,
                  screen: MusicScreen(),
                  assets: AppAssets.radioWave,
                ),
                SizedBox(
                  height: 20,
                ),
                _buttonItem(
                  title: "Radio World Wide",
                  item: HomeButtonItem.RADIO,
                  screen: RadioClass(),
                  assets: AppAssets.radio,
                ),
                SizedBox(
                  height: 20,
                ),
                _buttonItem(
                  title: "Disk Jockey",
                  item: HomeButtonItem.DJ,
                  screen: RadioClass(),
                  assets: AppAssets.djMixer,
                ),
                SizedBox(
                  height: 20,
                ),
                _buttonItem(
                    title: "Plan",
                    item: HomeButtonItem.PLAN,
                    screen: RadioClass(),
                    assets: AppAssets.plan),
                SizedBox(height: 15),
              ],
            ),
          )),
          BottomPlayingIndicator()
        ],
      ),
    );
  }

  Widget _buttonItem(
      {String title, String assets, Widget screen, HomeButtonItem item}) {
    return InkWell(
      onTap: () {
        setState(() {
          _homeButtonItem = item;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Container(
          decoration: BoxDecoration(
              color: _homeButtonItem != item
                  ? AppColor.transparent
                  : Colors.redAccent[100].withOpacity(0.8),
              border: Border.all(
                color: _homeButtonItem != item
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
                  assets,
                  color:
                      _homeButtonItem != item ? AppColor.white : AppColor.black,
                  height: 24,
                  width: 25,
                ),
                SizedBox(width: 10),
                TextViewWidget(
                  color:
                      _homeButtonItem != item ? AppColor.white : AppColor.black,
                  text: '$title',
                  textSize: 18,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Montserrat',
                ),
              ],
            ),
          )),
    );
  }
}

enum HomeButtonItem { NON, CONVERTER, CREATE_MUSIC, RADIO, DJ, PLAN }
