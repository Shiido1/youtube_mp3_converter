import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mp3_music_converter/screens/dashboard/main_dashboard.dart';
import 'package:mp3_music_converter/screens/world_radio/provider/radio_play_provider.dart';
import 'package:mp3_music_converter/screens/world_radio/provider/radio_provider.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/red_background.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:provider/provider.dart';

import 'model/radio_model.dart';

class RadioClass extends StatefulWidget {
  @override
  _RadioClassState createState() => _RadioClassState();
}

class _RadioClassState extends State<RadioClass>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  RadioProvider _radioProvider;
  bool tap = false;
  bool favRadio = false;
  String radioFile = '', radioMp3 = '';
  String placeName;
  bool isPlaying = false;
  bool isVisible = true;
  RadioPlayProvider _playProvider;

  List _favourites = [];
  var _currentStation;

  @override
  void initState() {
    _radioProvider = Provider.of<RadioProvider>(context, listen: false);
    _radioProvider.init(context);
    _playProvider = Provider.of<RadioPlayProvider>(context, listen: false);
    _playProvider.initPlayer();

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..repeat();
    if (radioFile.isNotEmpty && radioMp3.isNotEmpty) {
      _playProvider.playRadio(radioMp3);
    } else {
      init();
    }
  }

  init() {
    preferencesHelper
        .getStringValues(key: 'radiomp3')
        .then((value) => setState(() {
              radioMp3 = value;
            }));
    preferencesHelper
        .getStringValues(key: 'radioFile')
        .then((value) => setState(() {
              radioFile = value;
            }));
    preferencesHelper
        .getStringValues(key: 'placename')
        .then((value) => setState(() {
              placeName = value;
            }));
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
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: AppColor.background1,
      child: Column(
        children: [
          RedBackground(
            iconButton: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_outlined,
                color: AppColor.white,
              ),
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MainDashBoard()),
              ),
            ),
            text: 'Radio World Wide',
          ),
          Expanded(
            child: Stack(
              children: [
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
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 45,
                        width: 230,
                        color: Colors.red[200],
                        child: Center(
                          child: TextViewWidget(
                            color: AppColor.white,
                            text: placeName == null ? '' : '$placeName',
                            textSize: 20,
                          ),
                        ),
                      ),
                      tap == true
                          ? Container(
                              height: 340,
                              width: 230,
                              color: AppColor.black2,
                              child: (_radioProvider
                                              ?.radioModels?.radio?.length ??
                                          0) >
                                      0
                                  ? ListView.builder(
                                      itemCount: _radioProvider
                                              ?.radioModels?.radio?.length ??
                                          0,
                                      itemBuilder: (context, index) {
                                        var _radioLog = _radioProvider
                                            .radioModels.radio[index];

                                        return Card(
                                          color: AppColor.black2,
                                          child: ListTile(
                                            onTap: () {
                                              _currentStation = _radioLog;
                                              setState(() {
                                                radioFile = _radioLog.name;
                                                radioMp3 = _radioLog.mp3;
                                                isPlaying = true;
                                              });
                                              preferencesHelper.saveValue(
                                                  key: 'radiomp3',
                                                  value: radioMp3);
                                              preferencesHelper.saveValue(
                                                  key: 'radioFile',
                                                  value: radioFile);
                                              _playProvider.playAudio(radioMp3);
                                            },
                                            title: TextViewWidget(
                                              text: _radioLog.name,
                                              color: AppColor.white,
                                              textSize: 16,
                                            ),
                                            trailing: InkWell(
                                              onTap: () {
                                                print(jsonEncode(_favourites));
                                                _favourites.contains(_radioLog)
                                                    ? setState(
                                                        () => _favourites
                                                            .remove(_radioLog),
                                                      )
                                                    : setState(
                                                        () => _favourites
                                                            .add(_radioLog),
                                                      );
                                              },
                                              child: SvgPicture.asset(
                                                AppAssets.favourite,
                                                height: 25,
                                                width: 25,
                                                color: _favourites
                                                        .contains(_radioLog)
                                                    ? AppColor.red
                                                    : AppColor.white,
                                              ),
                                            ),
                                          ),
                                        );

                                        //  InkWell(
                                        //   onTap: () {
                                        //     setState(() {
                                        //       radioFile = _radioLog.name;
                                        //       radioMp3 = _radioLog.mp3;
                                        //       isPlaying = true;
                                        //     });
                                        //     preferencesHelper.saveValue(
                                        //         key: 'radiomp3',
                                        //         value: radioMp3);
                                        //     preferencesHelper.saveValue(
                                        //         key: 'radioFile',
                                        //         value: radioFile);
                                        //     _playProvider.playAudio(radioMp3);
                                        //   },
                                        //   child: Column(
                                        //     children: [
                                        //       TextViewWidget(
                                        //         text: _radioLog.name,
                                        //         color: AppColor.white,
                                        //         textSize: 16,
                                        //       ),
                                        //       Divider(
                                        //           thickness: 1,
                                        //           color: AppColor.white)
                                        //     ],
                                        //   ),
                                        // );
                                      })
                                  : Center(
                                      child: Text(
                                        'No Station',
                                        style: TextStyle(color: AppColor.white),
                                      ),
                                    ),
                            )
                          : Container(),
                      Container(
                        width: 230,
                        height: 50,
                        color: Colors.red[400],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  tap = !tap;
                                });
                              },
                              child: SvgPicture.asset(
                                AppAssets.bookmark,
                                height: 25,
                                width: 25,
                              ),
                            ),
                            SvgPicture.asset(
                              AppAssets.favourite,
                              height: 25,
                              width: 25,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(color: AppColor.black2),
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextViewWidget(
                        text: '$radioFile',
                        color: AppColor.white,
                        textSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4, bottom: 20),
                      child: Row(
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.skip_previous_outlined,
                                color: AppColor.white,
                                size: 50,
                              ),
                              onPressed: () {
                                int index = _radioProvider.radioModels.radio
                                    .indexWhere((var element) =>
                                        element.name == _currentStation.name);
                                if (index != 0)
                                  setState(() {
                                    _currentStation = _radioProvider
                                        .radioModels.radio[index - 1];
                                    radioFile = _currentStation.name;
                                    _playProvider
                                        .playAudio(_currentStation.mp3);
                                  });
                              }),

                          IconButton(
                            icon: isPlaying
                                ? Icon(
                                    Icons.pause_circle_outline,
                                    size: 50,
                                    color: AppColor.white,
                                  )
                                : Icon(
                                    Icons.play_circle_outline,
                                    color: AppColor.white,
                                    size: 50,
                                  ),
                            onPressed: () {
                              setState(() {
                                isPlaying = !isPlaying;
                              });
                              _playProvider.playAudio(radioMp3);
                            },
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.skip_next_outlined,
                                size: 48,
                                color: AppColor.white,
                              ),
                              onPressed: () {
                                print('pressed');
                                int index = _radioProvider.radioModels.radio
                                    .indexWhere((var element) =>
                                        element.name == _currentStation.name);
                                if (index <
                                    _radioProvider.radioModels.radio.length)
                                  setState(() {
                                    _currentStation = _radioProvider
                                        .radioModels.radio[index + 1];
                                    radioFile = _currentStation.name;
                                    _playProvider
                                        .playAudio(_currentStation.mp3);
                                  });
                              }),
                          // SizedBox(
                          //   width: 7,
                          // ),
                          // SvgPicture.asset(AppAssets.next,
                          //     height: 30, width: 30),
                          // SizedBox(
                          //   width: 6,
                          // ),
                          // SvgPicture.asset(
                          //   AppAssets.favorite,
                          // ),
                          // Expanded(
                          //   child: SizedBox(
                          //     width: 5,
                          //   ),
                          // ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => null,
                        icon: Icon(Icons.favorite,
                            size: 34, color: AppColor.white),
                      ),
                      SizedBox(
                        width: 3,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
