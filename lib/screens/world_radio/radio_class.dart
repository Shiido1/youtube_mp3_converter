import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:mp3_music_converter/screens/dashboard/main_dashboard.dart';
import 'package:mp3_music_converter/screens/world_radio/provider/radio_play_provider.dart';
import 'package:mp3_music_converter/screens/world_radio/provider/radio_provider.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/red_background.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:provider/provider.dart';

class RadioClass extends StatefulWidget {
  @override
  _RadioClassState createState() => _RadioClassState();
}

class _RadioClassState extends State<RadioClass>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  RadioProvider _radioProvider;
  bool tap;
  bool favRadio = false;
  String radioFile = '', radioMp3 = '';
  String placeName;
  bool isPlaying = false;
  bool isVisible = true;
  RadioPlayProvider _playProvider;
  int currentRadioIndex;
  List favourite = [];
  bool isFavourite = false;
  String selectedTab = "radio";

  @override
  void initState() {
    _radioProvider = Provider.of<RadioProvider>(context, listen: false);
    _radioProvider.init(context);
    _playProvider = Provider.of<RadioPlayProvider>(context, listen: false);
    _playProvider.initPlayer();
    tap = false;

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..repeat();
    if (radioFile.isNotEmpty && radioMp3.isNotEmpty) {
      _playProvider.playRadio(radioMp3);
    } else {
      init();
    }

    getFavourites();
    super.initState();
  }

  init() async {
    radioMp3 = await preferencesHelper.getStringValues(key: 'radiomp3');
    radioFile = await preferencesHelper.getStringValues(key: 'radioFile');
    placeName = await preferencesHelper.getStringValues(key: 'placename');
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  getFavourites() async {
    var box = await Hive.openBox('testBox');
    var _favourite = await box.get('fav');
    print(_favourite);
    if (_favourite != null) {
      setState(() {
        favourite = _favourite;
      });
      checkFavourite();
    } else {
      box.put('fav', []);
    }
  }

  checkFavourite() async {
    if (favourite.length > 0) {
      for (var map in favourite) {
        if (json.decode(map)["name"] == radioFile) {
          // file already added to favourite
          // remove file
          setState(() {
            isFavourite = true;
          });
          break;
        } else {
          setState(() {
            isFavourite = false;
          });
        }
      }
    }
  }

  addFavourite() async {
    var box = await Hive.openBox('testBox');
    var _favourite = box.get('fav');
    var _radioLog = _radioProvider.radioModels.radio[currentRadioIndex];

    if (currentRadioIndex != null) {
      if (_favourite != null) {
        print(_favourite);
        if (_favourite.contains(json.encode({
          'name': _radioLog.name,
          'mp3': _radioLog.mp3,
        }))) {
          print("already added to favourite, removing...");
          for (var map in _favourite) {
            if (json.decode(map)["name"] == radioFile) {
              // file already added to favourite
              // remove file
              _favourite.remove(map);
              box.put('fav', _favourite);
              setState(() {
                favourite = _favourite;
                isFavourite = false;
              });
              print("Removed from in fav..");
              break;
            }
            // print(json.decode(map));
          }
        } else {
          print("Adding to favourite");
          setState(() {
            favourite = _favourite;
            favourite.add(json.encode({
              'name': _radioLog.name,
              'mp3': _radioLog.mp3,
            }));
          });
          box.put('fav', favourite);
          checkFavourite();

          print(json.encode({
            'name': _radioLog.name,
            'mp3': _radioLog.mp3,
          }));
        }
      } else {
        setState(() {
          favourite.add(_radioProvider.radioModels.radio[currentRadioIndex]);
        });
        box.put('fav', favourite);
        checkFavourite();
      }
    }

    // print('Name: ${box.get('fav')}');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RadioProvider>(builder: (_, radioProvider, __) {
      return Scaffold(
          backgroundColor: AppColor.background1,
          body: Stack(children: [
            Center(
              child: Column(children: [
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
                                  text: '$placeName'??'',
                                  textSize: 20,
                                ),
                              ),
                            ),
                            tap == false
                                ? Container()
                                : selectedTab == 'radio' && tap == true
                            ? Container(
                                        height: 340,
                                        width: 230,
                                        color: AppColor.black2,
                                        child: (radioProvider?.radioModels
                                                        ?.radio?.length ??
                                                    0) >
                                                0
                                            ?
                                        radioContainer(false, null, radioProvider)
                                            : buildCenter('No Station')
                                      )
                                    : Container(
                                        height: 340,
                                        width: 230,
                                        color: AppColor.black2,
                                        child: favourite.length > 0 ?
                                        radioContainer(true, favourite, null)
                                            : buildCenter('No favourite added.')
                                      ),
                            Container(
                              width: 230,
                              height: 50,
                              color: Colors.red[400],
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedTab = "radio";
                                        tap = !tap;
                                      });
                                    },
                                    child: SvgPicture.asset(
                                      AppAssets.bookmark,
                                      height: 25,
                                      width: 25,
                                    ),
                                  ),
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedTab = "favourite";
                                          tap = !tap;
                                        });
                                      },
                                      child: SvgPicture.asset(
                                        AppAssets.favourite,
                                        height: 25,
                                        width: 25,
                                      ))
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
                    padding:
                        const EdgeInsets.only(left: 15.0, top: 10, bottom: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextViewWidget(
                                text:'$radioFile'??'',
                                color: AppColor.white,
                                textSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Row(
                                children: [
                                  IconButton(
                                      icon: Icon(
                                        Icons.skip_previous_outlined,
                                        color: AppColor.white,
                                        size: 50,
                                      ),
                                      onPressed: () {
                                        if (selectedTab == "favourite") {
                                          int fav = int.parse(
                                              favourite[currentRadioIndex]);
                                          if (fav != 0 && fav != null) {
                                            var _radioLog = radioProvider
                                                .radioModels.radio[fav - 1];
                                            setState(() {
                                              radioFile = _radioLog.name;
                                              radioMp3 = _radioLog.mp3;
                                              isPlaying = true;
                                              currentRadioIndex = fav - 1;
                                            });
                                            preferencesHelper.saveValue(
                                                key: 'radiomp3',
                                                value: radioMp3);
                                            preferencesHelper.saveValue(
                                                key: 'radioFile',
                                                value: radioFile);
                                            _playProvider.playRadio(radioMp3);
                                            checkFavourite();
                                          }
                                        } else {
                                          if (currentRadioIndex != 0 &&
                                              currentRadioIndex != null) {
                                            var _radioLog = radioProvider
                                                .radioModels
                                                .radio[currentRadioIndex - 1];
                                            setState(() {
                                              radioFile = _radioLog.name;
                                              radioMp3 = _radioLog.mp3;
                                              isPlaying = true;
                                              currentRadioIndex =
                                                  currentRadioIndex - 1;
                                            });
                                            preferencesHelper.saveValue(
                                                key: 'radiomp3',
                                                value: radioMp3);
                                            preferencesHelper.saveValue(
                                                key: 'radioFile',
                                                value: radioFile);
                                            _playProvider.playRadio(radioMp3);
                                            checkFavourite();
                                          }
                                        }
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
                                      _playProvider.playRadio(radioMp3);
                                    },
                                  ),
                                  IconButton(
                                      icon: Icon(
                                        Icons.skip_next_outlined,
                                        size: 48,
                                        color: AppColor.white,
                                      ),
                                      onPressed: () {
                                        if (currentRadioIndex !=
                                                radioProvider
                                                    .radioModels.radio.length &&
                                            currentRadioIndex != null) {
                                          var _radioLog = radioProvider
                                              .radioModels
                                              .radio[currentRadioIndex + 1];
                                          setState(() {
                                            radioFile = _radioLog.name;
                                            radioMp3 = _radioLog.mp3;
                                            isPlaying = true;
                                            currentRadioIndex =
                                                currentRadioIndex + 1;
                                          });
                                          preferencesHelper.saveValue(
                                              key: 'radiomp3', value: radioMp3);
                                          preferencesHelper.saveValue(
                                              key: 'radioFile',
                                              value: radioFile);
                                          _playProvider.playRadio(radioMp3);
                                          checkFavourite();
                                        }
                                      }),
                                  // }),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.favorite,
                                size: 34,
                                color:
                                    isFavourite ? Colors.red : AppColor.white),
                            onPressed: () {
                              addFavourite();
                            },
                          ),
                          SizedBox(
                            width: 3,
                          ),
                        ]),
                  ),
                )
              ]),
            ),
          ]));
    });
  }

  Widget radioContainer(bool isFavorite, List radioList, RadioProvider radioProvider )=> ListView.builder(
      itemCount: !isFavorite ? radioProvider
          ?.radioModels
          ?.radio
          ?.length ??
          0 : radioList.length ?? 0,
      itemBuilder: (context, index) {
        var _radioLog = isFavorite ? jsonDecode(radioList[index])
            : radioProvider
                .radioModels.radio[index];
        return InkWell(
          onTap: () {
            setState(() {
              currentRadioIndex =
                  index;
              radioFile =
                 isFavorite ? _radioLog["name"] : _radioLog.name;
              radioMp3 =
                  !isFavorite?_radioLog.mp3:_radioLog["mp3"];
              placeName =
                  !isFavorite?_radioLog.placeName:_radioLog["placeName"];
              isPlaying = true;
            });
            preferencesHelper
                .saveValue(
                key: 'radiomp3',
                value: radioMp3);
            preferencesHelper
                .saveValue(
                key: 'radioFile',
                value: radioFile);
            preferencesHelper
                .saveValue(
                key: 'placename',
                value: placeName);
            checkFavourite();
            _playProvider
                .playRadio(radioMp3);
          },
          child: Column(
            children: [
              TextViewWidget(
                text: !isFavorite ? _radioLog.name : _radioLog["name"],
                color: AppColor.white,
                textSize: 16,
              ),
              Divider(
                  thickness: 1,
                  color:
                  AppColor.white)
            ],
          ),
        );
      });

  buildCenter(String text) => Center(
    child: Text(
      text,
      style: TextStyle(
          color: AppColor.white),
    ),
  );
}
