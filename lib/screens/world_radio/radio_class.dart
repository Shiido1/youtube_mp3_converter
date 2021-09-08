import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_radio/flutter_radio.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mp3_music_converter/screens/world_radio/model/radio_model.dart'
    as radioModel;
import 'package:mp3_music_converter/screens/world_radio/provider/radio_play_provider.dart';
import 'package:mp3_music_converter/screens/world_radio/provider/radio_provider.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/red_background_backend/red_background.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RadioClass extends StatefulWidget {
  final String search;
  RadioClass({this.search});
  @override
  _RadioClassState createState() => _RadioClassState();
}

class _RadioClassState extends State<RadioClass>
    with SingleTickerProviderStateMixin {
  Completer<GoogleMapController> _mapController = Completer();
  AnimationController _controller;
  RadioProvider _radioProvider;
  TextEditingController _textController;
  bool tap = true;
  bool showChannels = false;
  bool favRadio = false;
  String radioFile = '', radioMp3 = '';
  String placeName;
  String placeId;
  String placeLat;
  String placeLong;
  bool isPlaying = false;
  bool showFaves = false;
  RadioPlayProvider _playProvider;
  int currentRadioIndex;
  List favourite = [];
  bool isFavourite = false;
  FocusNode _textFocusNode;
  final _formKey = GlobalKey<FormState>();
  Position location;
  bool showAllChannels;
  bool search = false;
  Map<MarkerId, Marker> markers = {};
  String searchString;
  bool notFound = false;
  Timer _timer;
  bool isLoading;
  bool mapLoaded = false;

  @override
  void initState() {
    _radioProvider = Provider.of<RadioProvider>(context, listen: false);
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
    if (widget.search != null) {
      searchString = widget.search;
      search = true;
    }

    getFavourites();
    getUserLocation();
    super.initState();
  }

  init() async {
    radioMp3 = await preferencesHelper.getStringValues(key: 'radiomp3');
    radioFile = await preferencesHelper.getStringValues(key: 'radioFile');
    placeName = await preferencesHelper.getStringValues(key: 'placename');
    placeId = await preferencesHelper.getStringValues(key: 'placeId');
    placeLat = await preferencesHelper.getStringValues(key: 'placeLat');
    placeLong = await preferencesHelper.getStringValues(key: 'placeLong');
    checkFavourite();
  }

  @override
  void deactivate() {
    Provider.of<RadioProvider>(context, listen: false)
        .updateShowAllChannels(false);
    super.deactivate();
  }

  _startTimer() {
    Duration time = Duration(seconds: 5);
    _timer = Timer(time, () {
      setState(() {
        notFound = false;
      });
    });
  }

  @override
  void dispose() {
    if (isPlaying) _playProvider.playRadio(radioMp3);
    _radioProvider.updateIsLoadingWithoutListener(true);
    _timer?.cancel();
    _controller.dispose();
    _textController.dispose();
    _textFocusNode.dispose();
    _radioProvider.radioModels = null;
    _mapController = null;
    super.dispose();
  }

  getFavourites() async {
    var box = await Hive.openBox('testBox');
    var _favourite = await box.get('fav');
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
    if (radioFile != null) {
      if (_favourite != null) {
        if (_favourite.contains(json.encode({
          'name': radioFile,
          'mp3': radioMp3,
          'placeId': placeId,
          'placename': placeName,
          'placeLat': placeLat,
          'placeLong': placeLong,
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
          }
        } else {
          setState(() {
            favourite = _favourite;
            favourite.add(json.encode({
              'name': radioFile,
              'mp3': radioMp3,
              'placeId': placeId,
              'placename': placeName,
              'placeLat': placeLat,
              'placeLong': placeLong,
            }));
          });
          box.put('fav', favourite);
          checkFavourite();
        }
      } else {
        radioModel.Radio station =
            _radioProvider.radioModels.radio[currentRadioIndex];
        setState(() {
          favourite.add(json.encode({
            'name': station.name,
            'mp3': station.mp3,
            'placeId': station.id,
            'placename': station.placeName,
            'placeLat': station.placeLat,
            'placeLong': station.placeLong,
          }));
        });
        box.put('fav', favourite);
        checkFavourite();
      }
    }
  }

  _addLocationMarker(
      {@required double latitude,
      @required double longitude,
      @required String title}) {
    MarkerId markerId = MarkerId('place');
    Marker marker = Marker(
        markerId: markerId,
        position: LatLng(latitude, longitude),
        infoWindow: InfoWindow(title: title),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan));
    markers[markerId] = marker;
    setState(() {});
  }

  _changeLocationMarker(
      {@required double latitude,
      @required double longitude,
      @required String title}) async {
    if (mounted) {
      final GoogleMapController controller = await _mapController.future;
      double zoomLevel = await controller.getZoomLevel();
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(latitude, longitude), zoom: zoomLevel)));

      markers.remove(MarkerId('place'));
      _addLocationMarker(
          latitude: latitude, longitude: longitude, title: title);
    }
  }

  permissionNotGranted() {
    if (searchString == null) {
      _radioProvider.init(context: context, search: false, searchData: '');
      setState(() {
        showAllChannels = true;
      });
    } else {
      _radioProvider.init(
          context: context, search: true, searchData: searchString);
      setState(() {
        showAllChannels = false;
      });
    }
  }

  getUserLocation() async {
    if (searchString == null) {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        showLocationMessage(
            message:
                'This function requires your location to be turned on. Do you want to turn it on?',
            type: 'location');
      } else {
        permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied ||
              permission == LocationPermission.deniedForever) {
            showLocationMessage(
                message:
                    'This function requires permission to access your location. Grant permission?',
                type: 'permission');
          } else
            getUserLocation();
        }
        if (permission == LocationPermission.deniedForever) {
          showLocationMessage(
              message:
                  'This function requires permission to access your location. Grant permission?',
              type: 'permission');
        }
        if (permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse) {
          print('im here');
          try {
            location = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high,
              timeLimit: Duration(seconds: 60),
            );

            setState(() {});
            GoogleMapController _controller = await _mapController.future;
            _controller.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(
                    target: LatLng(location.latitude, location.longitude),
                    zoom: 10)));
            List<Placemark> placemark = await placemarkFromCoordinates(
                location.latitude, location.longitude);

            _radioProvider.init(
                context: context,
                search: true,
                searchData: placemark[0].country);
          } catch (e) {
            _radioProvider.updateIsLoading(false);
            showToast(context,
                message: 'An error occurred. Try again later', gravity: 1);
          }
        }
      }
    } else
      _radioProvider.init(
        context: context,
        search: true,
        searchData: searchString,
      );
  }

  showLocationMessage({String message, String type}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              message,
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                child: Text('NO'),
                onPressed: () {
                  Navigator.pop(context);
                  permissionNotGranted();
                },
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  if (type == 'permission') await Geolocator.openAppSettings();
                  if (type == 'location')
                    await Geolocator.openLocationSettings();
                  getUserLocation();
                },
                child: Text('YES'),
              ),
            ],
          );
        });
  }

  checkIsPlaying() async {
    isPlaying = await FlutterRadio.isPlaying();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    showAllChannels = Provider.of<RadioProvider>(context).showAllChannels;
    checkIsPlaying();

    return Consumer<RadioProvider>(builder: (_, radioProvider, __) {
      isLoading = radioProvider.isLoading;
      if (searchString != null && radioProvider.radioModels != null)
        playStationFromSpeech(radioProvider);

      return Scaffold(
          backgroundColor: AppColor.background1,
          resizeToAvoidBottomInset: false,
          body: LoadingOverlay(
            isLoading: isLoading,
            color: Colors.white,
            opacity: 0.5,
            progressIndicator:
                SpinKitCircle(itemBuilder: (BuildContext context, int index) {
              return DecoratedBox(
                decoration: BoxDecoration(
                    color: index.isEven ? AppColor.white : AppColor.background,
                    shape: BoxShape.circle),
              );
            }),
            child: GestureDetector(
              onTap: () {
                _textFocusNode.unfocus();
              },
              child: Column(children: [
                Expanded(
                    child: Stack(alignment: Alignment.topCenter, children: [
                  Stack(
                    children: [
                      location == null
                          ? Positioned(
                              bottom: 5,
                              right: 20,
                              left: 20,
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
                                  )))
                          : GoogleMap(
                              initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                      37.42796133580664, -122.085749655962),
                                  tilt: 60,
                                  bearing: 90),
                              myLocationButtonEnabled: false,
                              markers: Set<Marker>.of(markers.values),
                              onMapCreated: (controller) {
                                _mapController.complete(controller);
                                setState(() {
                                  mapLoaded = true;
                                });
                                _addLocationMarker(
                                    latitude: location.latitude,
                                    longitude: location.longitude,
                                    title: "My Location");
                              },
                              zoomControlsEnabled: false,
                            ),
                      Positioned(
                        top: height >= 540 ? 250 : 132,
                        left: 30,
                        right: 20,
                        height: 50,
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            onFieldSubmitted: (value) {
                              if (_formKey.currentState.validate()) {
                                _radioProvider.updateIsLoading(true);
                                radioProvider.init(
                                    context: context,
                                    search: true,
                                    searchData: _textController.text);
                              }

                              setState(() {
                                _radioProvider.updateShowAllChannels(false);
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
                              fillColor: Colors.grey,
                              filled: true,
                              suffixIcon: IconButton(
                                  color: AppColor.bottomRed,
                                  icon: Icon(
                                    Icons.search,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      _radioProvider.updateIsLoading(true);
                                      _textFocusNode.unfocus();
                                      radioProvider.init(
                                          context: context,
                                          search: true,
                                          searchData: _textController.text);

                                      setState(() {
                                        _radioProvider
                                            .updateShowAllChannels(false);
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
                                  )),
                              height: 45,
                              width: 230,
                              child: Center(
                                child: TextViewWidget(
                                  color: AppColor.white,
                                  text: placeName ?? '',
                                  textSize: 20,
                                ),
                              ),
                            ),
                            if (showChannels == false && showFaves == false)
                              Container(),
                            if (showChannels)
                              Container(
                                  height: height < 540
                                      ? height - 340
                                      : height < 800
                                          ? height - 460
                                          : height - 480,
                                  width: 230,
                                  color: AppColor.black2,
                                  child: (radioProvider?.radioModels?.radio
                                                  ?.length ??
                                              0) >
                                          0
                                      ? radioContainer(
                                          false, null, radioProvider)
                                      : buildCenter('No Station')),
                            if (showFaves)
                              Container(
                                height: height < 540
                                    ? height - 340
                                    : height < 800
                                        ? height - 460
                                        : height - 480,
                                width: 230,
                                color: AppColor.black2,
                                child: favourite.length > 0
                                    ? radioContainer(true, favourite, null)
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
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      RedBackground(
                        iconButton: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios_outlined,
                              color: AppColor.white,
                            ),
                            onPressed: () => Navigator.pop(context)),
                        text: 'Radio World Wide',
                      ),
                      Positioned(
                        top: height < 540 ? 90 : 120,
                        left: height < 540 ? 70 : 40,
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
                                  _radioProvider.updateIsLoading(true);
                                  radioProvider.init(
                                      context: context,
                                      search: false,
                                      searchData: '');
                                  _textController.clear();
                                  _textFocusNode.unfocus();

                                  _radioProvider.updateShowAllChannels(value);
                                }
                              },
                              valueFontSize: 15,
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
                      if (notFound)
                        Positioned(
                          top: MediaQuery.of(context).viewPadding.top + 10,
                          child: Container(
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: const Color(2852126720),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Text('Station not found',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                    ],
                  ),
                ])),
                Container(
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(color: AppColor.black2),
                  child: Padding(
                    padding: height >= 800
                        ? const EdgeInsets.only(left: 15.0, top: 10, bottom: 10)
                        : const EdgeInsets.only(left: 15.0, top: 0, bottom: 0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextViewWidget(
                                text: radioFile ?? '',
                                color: AppColor.white,
                                textSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                            favourite[currentRadioIndex - 1]);
                                        if (isPlaying)
                                          _playProvider.playRadio(radioMp3);
                                        setState(() {
                                          radioFile = _radioLog["name"];
                                          radioMp3 = _radioLog["mp3"];
                                          placeName = _radioLog["placename"];
                                          placeId = _radioLog["placeId"];
                                          placeLat = _radioLog["placeLat"];
                                          placeLong = _radioLog["placeLong"];
                                          currentRadioIndex =
                                              currentRadioIndex - 1;
                                        });
                                        if (location == null)
                                          location = Position(
                                              latitude: double.parse(
                                                  _radioLog['placeLat']
                                                      .toString()),
                                              longitude: double.parse(
                                                  _radioLog['placeLong']
                                                      .toString()));
                                        _changeLocationMarker(
                                            latitude: double.parse(
                                                    _radioLog['placeLat']
                                                        .toString()) ??
                                                location.latitude,
                                            longitude: double.parse(
                                                    _radioLog['placeLong']
                                                        .toString()) ??
                                                location.longitude,
                                            title: _radioLog["name"]);
                                        preferencesHelper.saveValue(
                                            key: 'radiomp3', value: radioMp3);
                                        preferencesHelper.saveValue(
                                            key: 'radioFile', value: radioFile);
                                        preferencesHelper.saveValue(
                                            key: 'placename', value: placeName);
                                        preferencesHelper.saveValue(
                                            key: 'placeId', value: placeId);
                                        preferencesHelper.saveValue(
                                            key: 'placeLat', value: placeLat);
                                        preferencesHelper.saveValue(
                                            key: 'placeLong', value: placeLong);
                                        _playProvider.playRadio(radioMp3);
                                        checkFavourite();
                                      }
                                    } else {
                                      var _radioLog;
                                      if (currentRadioIndex == null &&
                                          _radioProvider.radioModels.radio.any(
                                              (element) =>
                                                  element.id == placeId)) {
                                        currentRadioIndex = _radioProvider
                                            .radioModels.radio
                                            .indexWhere((element) =>
                                                element.id == placeId);
                                      }
                                      if (currentRadioIndex == null &&
                                          _radioProvider.radioModels.radio.any(
                                              (element) =>
                                                  element.id == placeId)) {
                                        currentRadioIndex = _radioProvider
                                            .radioModels.radio
                                            .indexWhere((element) =>
                                                element.id == placeId);
                                      }
                                      if (!(_radioProvider.radioModels.radio
                                              .any((element) =>
                                                  element.id == placeId)) &&
                                          !search) {
                                        currentRadioIndex = 0;
                                        _radioLog =
                                            radioProvider.radioModels.radio[0];
                                      } else if (currentRadioIndex != null &&
                                          currentRadioIndex > 0) {
                                        _radioLog = search
                                            ? radioProvider.radioModelsItems
                                                .radio[currentRadioIndex - 1]
                                            : radioProvider.radioModels
                                                .radio[currentRadioIndex - 1];
                                        if (isPlaying)
                                          _playProvider.playRadio(radioMp3);
                                        setState(() {
                                          radioFile = _radioLog.name;
                                          radioMp3 = _radioLog.mp3;
                                          placeName = _radioLog.placeName;
                                          placeId = _radioLog.id;
                                          placeLat = _radioLog.placeLat;
                                          placeLong = _radioLog.placeLong;
                                          currentRadioIndex =
                                              currentRadioIndex - 1;
                                        });
                                        if (location == null)
                                          location = Position(
                                              latitude: double.parse(_radioLog
                                                  .placeLat
                                                  .toString()),
                                              longitude: double.parse(_radioLog
                                                  .placeLong
                                                  .toString()));
                                        _changeLocationMarker(
                                            latitude: double.parse(
                                                _radioLog.placeLat.toString()),
                                            longitude: double.parse(
                                                _radioLog.placeLong.toString()),
                                            title: _radioLog.name);
                                        preferencesHelper.saveValue(
                                            key: 'radiomp3', value: radioMp3);
                                        preferencesHelper.saveValue(
                                            key: 'radioFile', value: radioFile);
                                        preferencesHelper.saveValue(
                                            key: 'placename', value: placeName);
                                        preferencesHelper.saveValue(
                                            key: 'placeId', value: placeId);
                                        preferencesHelper.saveValue(
                                            key: 'placeLat', value: placeLat);
                                        preferencesHelper.saveValue(
                                            key: 'placeLong', value: placeLong);
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
                                    if (!tap) {
                                      if (currentRadioIndex != null &&
                                          currentRadioIndex <
                                              favourite.length - 1) {
                                        var _radioLog = json.decode(
                                            favourite[currentRadioIndex + 1]);
                                        if (isPlaying)
                                          _playProvider.playRadio(radioMp3);
                                        setState(() {
                                          radioFile = _radioLog["name"];
                                          radioMp3 = _radioLog["mp3"];
                                          placeName = _radioLog["placename"];
                                          placeId = _radioLog['placeId'];
                                          placeLat = _radioLog["placeLat"];
                                          placeLong = _radioLog['placeLong'];
                                          currentRadioIndex =
                                              currentRadioIndex + 1;
                                        });
                                        if (location == null)
                                          location = Position(
                                              latitude: double.parse(
                                                  _radioLog['placeLat']
                                                      .toString()),
                                              longitude: double.parse(
                                                  _radioLog['placeLong']
                                                      .toString()));
                                        _changeLocationMarker(
                                            latitude: double.parse(
                                                    _radioLog['placeLat']
                                                        .toString()) ??
                                                location.latitude,
                                            longitude: double.parse(
                                                    _radioLog['placeLong']
                                                        .toString()) ??
                                                location.longitude,
                                            title: _radioLog["name"]);
                                        preferencesHelper.saveValue(
                                            key: 'radiomp3', value: radioMp3);
                                        preferencesHelper.saveValue(
                                            key: 'radioFile', value: radioFile);
                                        preferencesHelper.saveValue(
                                            key: 'placename', value: placeName);
                                        preferencesHelper.saveValue(
                                            key: 'placeId', value: placeId);
                                        preferencesHelper.saveValue(
                                            key: 'placeLat', value: placeLat);
                                        preferencesHelper.saveValue(
                                            key: 'placeLong', value: placeLong);
                                        _playProvider.playRadio(radioMp3);
                                        checkFavourite();
                                      }
                                    } else {
                                      var _radioLog;
                                      if (currentRadioIndex == null &&
                                          _radioProvider.radioModels.radio.any(
                                              (element) =>
                                                  element.id == placeId)) {
                                        currentRadioIndex = _radioProvider
                                            .radioModels.radio
                                            .indexWhere((element) =>
                                                element.id == placeId);
                                      }
                                      if (!(_radioProvider.radioModels.radio
                                              .any((element) =>
                                                  element.id == placeId)) &&
                                          !search) {
                                        currentRadioIndex = 0;
                                        _radioLog =
                                            radioProvider.radioModels.radio[0];
                                      } else if (search) {
                                        if (currentRadioIndex != null &&
                                            currentRadioIndex <
                                                radioProvider.radioModelsItems
                                                        .radio.length -
                                                    1) {
                                          _radioLog = radioProvider
                                              .radioModelsItems
                                              .radio[currentRadioIndex + 1];
                                        }
                                      } else {
                                        if (currentRadioIndex != null &&
                                            currentRadioIndex <
                                                radioProvider.radioModels.radio
                                                        .length -
                                                    1) {
                                          _radioLog = radioProvider.radioModels
                                              .radio[currentRadioIndex + 1];
                                        }
                                      }
                                      if (isPlaying)
                                        _playProvider.playRadio(radioMp3);
                                      setState(() {
                                        radioFile = _radioLog.name;
                                        radioMp3 = _radioLog.mp3;
                                        placeName = _radioLog.placeName;
                                        placeId = _radioLog.id;
                                        placeLat = _radioLog.placeLat;
                                        placeLong = _radioLog.placeLong;
                                        currentRadioIndex =
                                            currentRadioIndex + 1;
                                      });
                                      if (location == null)
                                        location = Position(
                                            latitude: double.parse(
                                                _radioLog.placeLat.toString()),
                                            longitude: double.parse(_radioLog
                                                .placeLong
                                                .toString()));
                                      _changeLocationMarker(
                                          latitude: double.parse(
                                              _radioLog.placeLat.toString()),
                                          longitude: double.parse(
                                              _radioLog.placeLong.toString()),
                                          title: _radioLog.name);
                                      preferencesHelper.saveValue(
                                          key: 'radiomp3', value: radioMp3);
                                      preferencesHelper.saveValue(
                                          key: 'radioFile', value: radioFile);
                                      preferencesHelper.saveValue(
                                          key: 'placename', value: placeName);
                                      preferencesHelper.saveValue(
                                          key: 'placeId', value: placeId);
                                      preferencesHelper.saveValue(
                                          key: 'placeLat', value: placeLat);
                                      preferencesHelper.saveValue(
                                          key: 'placeLong', value: placeLong);
                                      _playProvider.playRadio(radioMp3);
                                      checkFavourite();
                                    }
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: IconButton(
                                    icon: Icon(Icons.favorite,
                                        size: 34,
                                        color: isFavourite
                                            ? Colors.red
                                            : AppColor.white),
                                    onPressed: () {
                                      addFavourite();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // SizedBox(width:29,),

                          SizedBox(width: 3),
                        ]),
                  ),
                ),
              ]),
            ),
          ));
    });
  }

  Widget radioContainer(
      bool isFavorite, List radioList, RadioProvider radioProvider) {
    return ListView.builder(
        itemCount: !isFavorite
            ? radioProvider?.radioModels?.radio?.length ?? 0
            : radioList.length ?? 0,
        itemBuilder: (context, index) {
          var _radioLog = isFavorite
              ? jsonDecode(radioList[index])
              : radioProvider.radioModels.radio[index];
          bool currentStation = isFavorite
              ? _radioLog['placeId'] == placeId
              : _radioLog.id == placeId;

          return InkWell(
            onTap: () {
              setState(() {
                currentRadioIndex = index;
                if (location == null)
                  location = Position(
                      latitude: !isFavorite
                          ? double.parse(_radioLog.placeLat.toString())
                          : double.parse(_radioLog['placeLat'].toString()),
                      longitude: !isFavorite
                          ? double.parse(_radioLog.placeLong.toString())
                          : double.parse(_radioLog['placeLong'].toString()));
                tap = showFaves ? false : true;
                search = false;
                if (isPlaying) _playProvider.playRadio(radioMp3);
                radioFile = isFavorite ? _radioLog["name"] : _radioLog.name;
                radioMp3 = !isFavorite ? _radioLog.mp3 : _radioLog["mp3"];
                placeName =
                    !isFavorite ? _radioLog.placeName : _radioLog["placename"];
                placeId = !isFavorite ? _radioLog.id : _radioLog["placeId"];
                placeLat = !isFavorite
                    ? _radioLog.placeLat
                    : _radioLog["placeLat"] ?? location.latitude.toString();
                placeLong = !isFavorite
                    ? _radioLog.placeLong
                    : _radioLog["placeLong"] ?? location.longitude.toString();
              });

              _changeLocationMarker(
                  latitude: !isFavorite
                      ? double.parse(_radioLog.placeLat.toString())
                      : double.parse(_radioLog['placeLat'].toString()) ??
                          location.latitude,
                  longitude: !isFavorite
                      ? double.parse(_radioLog.placeLong.toString())
                      : double.parse(_radioLog['placeLong'].toString()) ??
                          location.longitude,
                  title: isFavorite ? _radioLog["name"] : _radioLog.name);
              preferencesHelper.saveValue(key: 'radiomp3', value: radioMp3);
              preferencesHelper.saveValue(key: 'radioFile', value: radioFile);
              preferencesHelper.saveValue(key: 'placename', value: placeName);
              preferencesHelper.saveValue(key: 'placeId', value: placeId);
              preferencesHelper.saveValue(key: 'placeLat', value: placeLat);
              preferencesHelper.saveValue(key: 'placeLong', value: placeLong);

              checkFavourite();
              _playProvider.playRadio(radioMp3);
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
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
                    child: Divider(thickness: 1, color: AppColor.white),
                  )
                ],
              ),
            ),
          );
        });
  }

  buildCenter(String text) => Center(
        child: Text(
          text,
          style: TextStyle(color: AppColor.white),
        ),
      );

  playStationFromSpeech(RadioProvider radioProvider) async {
    var _radioLog = radioProvider.radioModels.radio.length > 0
        ? radioProvider?.radioModels?.radio[0]
        : null;

    if (_radioLog == null) {
      _startTimer();
      searchString = null;
      search = false;
      notFound = true;
    } else {
      searchString = null;
      search = false;
      radioFile = _radioLog.name;
      radioMp3 = _radioLog.mp3;
      placeName = _radioLog.placeName;
      placeId = _radioLog.id;
      placeLat = _radioLog.placeLat;
      placeLong = _radioLog.placeLong;
      checkFavourite();

      preferencesHelper.saveValue(key: 'radiomp3', value: radioMp3);
      preferencesHelper.saveValue(key: 'radioFile', value: radioFile);
      preferencesHelper.saveValue(key: 'placename', value: placeName);
      preferencesHelper.saveValue(key: 'placeId', value: placeId);
      preferencesHelper.saveValue(key: 'placeLat', value: placeLat);
      preferencesHelper.saveValue(key: 'placeLong', value: placeLong);

      _playProvider.playRadio(radioMp3);
      location = Position(
          latitude: double.parse(placeLat), longitude: double.parse(placeLong));
      _changeLocationMarker(
          latitude: location.latitude,
          longitude: location.longitude,
          title: placeName);
    }
  }
}
