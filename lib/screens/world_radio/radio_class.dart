import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:mp3_music_converter/screens/world_radio/model/radio_model.dart'
as radioModel;
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
  TextEditingController _textController;
  bool tap = true;
  bool showChannels = false;
  bool favRadio = false;
  String radioFile = '', radioMp3 = '';
  String placeName;
  String placeId;
  bool isPlaying = false;
  bool showFaves = false;
  RadioPlayProvider _playProvider;
  int currentRadioIndex;
  List favourite = [];
  bool isFavourite = false;
  FocusNode _textFocusNode;
  final _formKey = GlobalKey<FormState>();
  Position location;
  bool showAllChannels = true;
  bool search = false;

  @override
  void initState() {
    _radioProvider = Provider.of<RadioProvider>(context, listen: false);
    _radioProvider.init(context: context, search: false, searchData: '');
    _playProvider = Provider.of<RadioPlayProvider>(context, listen: false);
    _playProvider.initPlayer();
    _textController = TextEditingController()..addListener(() {});
    _textFocusNode = FocusNode();

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
    placeId = await preferencesHelper.getStringValues(key: 'placeId');
    setState(() {});
  }

  @override
  void dispose() {
    if (isPlaying) _playProvider.playRadio(radioMp3);
    _controller.dispose();
    _textController.dispose();
    _textFocusNode.dispose();
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

  checkStation() {
    if (!(_radioProvider.radioModels.radio
        .any((element) => element.id == placeId))) {
      _radioProvider.init(
          search: true, add: true, context: context, searchData: radioFile);
    }
    if (tap && !search) {
      int index = _radioProvider.radioModels.radio
          .indexWhere((element) => element.id == placeId);
      if (index == null)
        checkStation();
      else
        currentRadioIndex = index;

      setState(() {});
    }
  }

  checkFavourite() async {
    if (favourite.length > 0) {
      for (var map in favourite) {
        if (json.decode(map)["name"] == radioFile &&
            json.decode(map)["placeId"] == placeId) {
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
    var _radioLog;
    // if (favourite == null || favourite.isEmpty) tap = true;
    if (search)
      for (radioModel.Radio item in _radioProvider.radioModelsItems.radio) {
        if (item.name == radioFile && item.id == placeId) {
          _radioLog = item;
          break;
        }
      }
    else
      for (radioModel.Radio item in _radioProvider.radioModels.radio) {
        if (item.name == radioFile && item.id == placeId) {
          _radioLog = item;
          break;
        }
      }
    // var _radioLog = tap
    //     ? _radioProvider.radioModels.radio[currentRadioIndex]
    //     : json.decode(favourite[currentRadioIndex]);

    if (currentRadioIndex != null) {
      if (_favourite != null) {
        if (_favourite.contains(json.encode({
          'name': _radioLog.name,
          'mp3': _radioLog.mp3,
          'placeId': _radioLog.id,
          'placename': _radioLog.placeName,
        }))) {
          for (var map in _favourite) {
            if (json.decode(map)["name"] == radioFile &&
                json.decode(map)["placeId"] == placeId) {
              // file already added to favourite
              // remove file
              _favourite.remove(map);
              box.put('fav', _favourite);
              setState(() {
                favourite = _favourite;
                isFavourite = false;
              });
              break;
            }
            // print(json.decode(map));
          }
        } else {
          setState(() {
            favourite = _favourite;
            favourite.add(json.encode({
              'name': _radioLog.name,
              'mp3': _radioLog.mp3,
              'placeId': _radioLog.id,
              'placename': _radioLog.placeName,
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
  }

  @override
  Widget build(BuildContext context) {
    if (_radioProvider.radioModels != null && search == false) checkStation();
    return Consumer<RadioProvider>(builder: (_, radioProvider, __) {
      return Scaffold(
          backgroundColor: AppColor.background1,
          resizeToAvoidBottomInset: false,
          body: GestureDetector(
            onTap: () {
              _textFocusNode.unfocus();
            },
            child: Stack(children: [
              Center(
                child: Column(children: [
                  Stack(
                    children: [
                      RedBackground(
                        iconButton: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios_outlined,
                            color: AppColor.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        text: 'Radio World Wide',
                      ),
                      Positioned(
                        top: 35,
                        bottom: 0,
                        left: 35,
                        child: Row(
                          children: [
                            FlutterSwitch(
                              inactiveTextFontWeight: FontWeight.normal,
                              activeTextFontWeight: FontWeight.normal,
                              activeColor: Colors.red[200],
                              activeToggleColor: AppColor.bottomRed,
                              activeTextColor: Colors.black,
                              showOnOff: true,
                              value: showAllChannels,
                              inactiveToggleColor: Colors.black,
                              onToggle: (value) {
                                if (showAllChannels == false) {
                                  radioProvider.init(
                                      context: context,
                                      search: false,
                                      searchData: '');
                                  _textController.clear();
                                  _textFocusNode.unfocus();
                                  setState(() {
                                    showAllChannels = value;
                                  });
                                }
                              },
                              valueFontSize: 16,
                              height: 25,
                              width: 55,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Show all channels',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned(
                          top: 30,
                          left: 40,
                          right: 40,
                          height: 50,
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              onFieldSubmitted: (value) {
                                if (_formKey.currentState.validate()) {
                                  radioProvider.init(
                                      context: context,
                                      search: true,
                                      searchData: _textController.text);
                                }

                                setState(() {
                                  showAllChannels = false;
                                  showChannels = true;
                                  showFaves = false;
                                  search = true;
                                });
                              },
                              cursorColor: AppColor.bottomRed,
                              validator: (val) {
                                return val.trim().length > 2 ? null : '';
                              },
                              style: TextStyle(
                                  height: 1.5,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                              cursorHeight: 25,
                              focusNode: _textFocusNode,
                              textInputAction: TextInputAction.search,
                              scrollPadding: EdgeInsets.zero,
                              controller: _textController,
                              decoration: InputDecoration(
                                hintText: 'Enter location or channel name',
                                suffixIcon: IconButton(
                                    color: AppColor.bottomRed,
                                    icon: Icon(
                                      Icons.search,
                                      size: 30,
                                    ),
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        _textFocusNode.unfocus();
                                        radioProvider.init(
                                            context: context,
                                            search: true,
                                            searchData: _textController.text);

                                        setState(() {
                                          showAllChannels = false;
                                          showChannels = true;
                                          showFaves = false;
                                          search = true;
                                        });
                                      }
                                    }),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Colors.red[300], width: 2),
                                ),
                                errorStyle: TextStyle(fontSize: 0),
                                errorText: '',
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: AppColor.bottomRed, width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Colors.red[300], width: 2),
                                ),
                              ),
                            ),
                          ),
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
                                height: 320,
                                width: 300,
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
                                decoration: BoxDecoration(
                                    color: Colors.red[200],
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(12),
                                    )
                                ),
                                height: 45,
                                width: 230,
                                child: Center(
                                  child: TextViewWidget(
                                    color: AppColor.white,
                                    text: placeName??'',
                                    textSize: 20,
                                  ),
                                ),
                              ),
                              if (showChannels == false && showFaves == false)
                                Container(),
                              if (showChannels)
                                Container(
                                  height: 340,
                                  width: 230,
                                  color: AppColor.black2,
                                  child: (radioProvider?.radioModels?.radio
                                                  ?.length ??
                                              0) >
                                          0
                                      ?  radioContainer(false, null, radioProvider)
                                      : buildCenter('No Station')
                                ),
                              if (showFaves)
                                Container(
                                  height: 340,
                                  width: 230,
                                  color: AppColor.black2,
                                  child: favourite.length > 0
                                      ?
                                      radioContainer(true, favourite, null)
                                      : buildCenter('No Favorite Station'),
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
                                          showChannels = !showChannels;
                                          showFaves = false;
                                        });
                                      },
                                      child: SvgPicture.asset(
                                        AppAssets.bookmark,
                                        height: 25,
                                        width: 25,
                                        color: showChannels
                                            ? AppColor.white
                                            : AppColor.black,
                                      ),
                                    ),
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            showFaves = !showFaves;
                                            showChannels = false;
                                          });
                                        },
                                        child: SvgPicture.asset(
                                          AppAssets.favourite,
                                          height: 25,
                                          width: 25,
                                          color: showFaves
                                              ? AppColor.white
                                              : AppColor.black,
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
                      padding: const EdgeInsets.only(
                          left: 15.0, top: 10, bottom: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextViewWidget(
                                  text: radioFile??'',
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
                                        if (!tap) {
                                          if (currentRadioIndex != null &&
                                              currentRadioIndex > 0) {
                                            var _radioLog = json.decode(
                                                favourite[
                                                    currentRadioIndex - 1]);
                                            setState(() {
                                              radioFile = _radioLog["name"];
                                              radioMp3 = _radioLog["mp3"];
                                              placeName =
                                                  _radioLog["placename"];
                                              placeId = _radioLog["placeId"];
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
                                            preferencesHelper.saveValue(
                                                key: 'placename',
                                                value: placeName);
                                            preferencesHelper.saveValue(
                                                key: 'placeId', value: placeId);
                                            _playProvider.playRadio(radioMp3);
                                            checkFavourite();
                                          }
                                        } else {
                                          if (currentRadioIndex != null &&
                                              currentRadioIndex > 0) {
                                            var _radioLog = search
                                                ? radioProvider
                                                        .radioModelsItems.radio[
                                                    currentRadioIndex - 1]
                                                : radioProvider
                                                        .radioModels.radio[
                                                    currentRadioIndex - 1];

                                            setState(() {
                                              radioFile = _radioLog.name;
                                              radioMp3 = _radioLog.mp3;
                                              placeName = _radioLog.placeName;
                                              placeId = _radioLog.id;
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
                                            preferencesHelper.saveValue(
                                                key: 'placename',
                                                value: placeName);
                                            preferencesHelper.saveValue(
                                                key: 'placeId', value: placeId);
                                            _playProvider.playRadio(radioMp3);
                                            checkFavourite();
                                          }
                                        }
                                      },
                                    ),
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
                                    Expanded(
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.skip_next_outlined,
                                          size: 48,
                                          color: AppColor.white,
                                        ),
                                        onPressed: () {
                                          if (!tap) {
                                            if (currentRadioIndex != null &&
                                                currentRadioIndex <
                                                    favourite.length - 1) {
                                              var _radioLog = json.decode(
                                                  favourite[
                                                      currentRadioIndex + 1]);
                                              setState(() {
                                                radioFile = _radioLog["name"];
                                                radioMp3 = _radioLog["mp3"];
                                                placeName =
                                                    _radioLog["placename"];
                                                placeId = _radioLog['placeId'];
                                                isPlaying = true;
                                                currentRadioIndex =
                                                    currentRadioIndex + 1;
                                              });
                                              preferencesHelper.saveValue(
                                                  key: 'radiomp3',
                                                  value: radioMp3);
                                              preferencesHelper.saveValue(
                                                  key: 'radioFile',
                                                  value: radioFile);
                                              preferencesHelper.saveValue(
                                                  key: 'placename',
                                                  value: placeName);
                                              preferencesHelper.saveValue(
                                                  key: 'placeId', value: placeId);
                                              _playProvider.playRadio(radioMp3);
                                              checkFavourite();
                                            }
                                          } else {
                                            var _radioLog;
                                            if (search) {
                                              if (currentRadioIndex != null &&
                                                  currentRadioIndex <
                                                      radioProvider
                                                              .radioModelsItems
                                                              .radio
                                                              .length -
                                                          1) {
                                                _radioLog = radioProvider
                                                    .radioModelsItems
                                                    .radio[currentRadioIndex + 1];
                                              }
                                            } else {
                                              if (currentRadioIndex != null &&
                                                  currentRadioIndex <
                                                      radioProvider.radioModels
                                                              .radio.length -
                                                          1) {
                                                _radioLog = radioProvider
                                                    .radioModels
                                                    .radio[currentRadioIndex + 1];
                                              }
                                            }
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
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 25,),
                            IconButton(
                              icon: Icon(Icons.favorite,
                                  size: 34,
                                  color: isFavourite
                                      ? Colors.red
                                      : AppColor.white),
                              onPressed: () {
                                addFavourite();
                              },
                            ),

                          ]),
                    ),
                  )
                ]),
              ),
            ]),
          ));
    });
  }

  Widget radioContainer(
      bool isFavorite,
      List radioList,
      RadioProvider radioProvider)=> ListView.builder(
      itemCount: !isFavorite ? radioProvider
          ?.radioModels
          ?.radio
          ?.length ??
          0 : radioList.length ?? 0,
      itemBuilder: (context, index) {
        var _radioLog = isFavorite ? jsonDecode(radioList[index])
            : radioProvider
                .radioModels.radio[index];
        bool currentStation =
        isFavorite?_radioLog['placeId'] == placeId:_radioLog.id == placeId
            ? true
            : false;
        return InkWell(
          onTap: () {
            setState(() {
              currentRadioIndex =
                  index;
              !isFavorite?tap = true:tap=false;
              search = false;
              radioFile =
                 isFavorite ? _radioLog["name"] : _radioLog.name;
              radioMp3 =
                  !isFavorite?_radioLog.mp3:_radioLog["mp3"];
              placeName =
                  !isFavorite?_radioLog.placeName:_radioLog["placename"];
              placeId =
              !isFavorite? _radioLog.id:_radioLog["placeId"];
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
            preferencesHelper.saveValue(
                key: 'placeId', value: placeId);
            checkFavourite();
            _playProvider
                .playRadio(radioMp3);
          },
          child: Padding(
            padding: const EdgeInsets.only(left:10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextViewWidget(
                  text: !isFavorite ? _radioLog.name : _radioLog["name"],
                  color: currentStation ? AppColor.bottomRed : AppColor.white,
                  textSize: 16,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Divider(
                      thickness: 1,
                      color:
                      AppColor.white),
                )
              ],
            ),
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
