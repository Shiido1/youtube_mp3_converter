import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mp3_music_converter/screens/converter/convert.dart';
import 'package:mp3_music_converter/screens/create_music/create_music_screen.dart';
import 'package:mp3_music_converter/screens/payment/payment_screen.dart';
import 'package:mp3_music_converter/screens/world_radio/radio_class.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/bottom_playlist_indicator.dart';
import 'package:mp3_music_converter/widgets/red_background.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:mp3_music_converter/utils/utilFold/linkShareAssistant.dart';

// ignore: must_be_immutable
class DashBoard extends StatefulWidget {
  int index;

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  HomeButtonItem _homeButtonItem = HomeButtonItem.NON;

  String _sharedText = "";

  @override
  void initState() {
    super.initState();

    // Create the share service
    LinkShareAssistant()
    // Register a callback so that we handle shared data if it arrives while the
    // app is running
      ..onDataReceived = _handleSharedData

    // Check to see if there is any shared data already, meaning that the app
    // was launched via sharing.
      ..getSharedData().then(_handleSharedData);
  }

  /// Handles any shared data we may receive.
  void _handleSharedData(String sharedData) {
    setState(() {
      _sharedText = sharedData;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (_sharedText.length>1)
      return Convert(sharedLinkText: _sharedText);
    else
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
                  screen: CreateMusicScreen(),
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
                    screen: PaymentScreen(),
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
