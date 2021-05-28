import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mp3_music_converter/bottom_navigation/my_library.dart';
import 'package:mp3_music_converter/bottom_navigation/playlist.dart';
import 'package:mp3_music_converter/bottom_navigation/search.dart';
import 'package:mp3_music_converter/bottom_navigation/setting.dart';
import 'package:mp3_music_converter/screens/dashboard/dashboard.dart';
import 'package:mp3_music_converter/screens/recorded/provider/record_provider.dart';
import 'package:mp3_music_converter/screens/song/provider/music_provider.dart';
import 'package:mp3_music_converter/screens/splitted/provider/splitted_song_provider.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MainDashBoard extends StatefulWidget {
  int index;

  @override
  _MainDashBoardState createState() => _MainDashBoardState();
}

class _MainDashBoardState extends State<MainDashBoard> {
  int _currentIndex = 0;
  MusicProvider _musicProvider;
  SplittedSongProvider _repository;
  RecordProvider _recordProvider;
  // RadioPlayProvider _playProvider;

  List<Widget> _screens = [
    DashBoard(),
    PlayList(),
    Library(),
    Search(),
    Setting()
  ];

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    _musicProvider = Provider.of<MusicProvider>(context, listen: false);
    await _musicProvider.initProvider();
    _repository = Provider.of<SplittedSongProvider>(context, listen: false);
    _repository.initProvider();
    _recordProvider = Provider.of<RecordProvider>(context, listen: false);
    await _recordProvider.initProvider();
    if (AudioService.queue == null || AudioService.queue.isEmpty)
      preferencesHelper.getStringValues(key: "last_play").then((data) {
        if (data != null) {
          Map value = json.decode(data);
          MediaItem item = MediaItem(
              album: value['album'],
              id: value['id'],
              title: value['title'],
              artist: value['artist'],
              extras: {
                'fileName': value['fileName'],
                'filePath': value['filePath'],
                'image': value['image'],
                'favourite': value['favourite']
              });

          _musicProvider.updateLocal(item);
        }
      }).catchError((error) {
        print(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        backgroundColor: AppColor.black,
        selectedItemColor: AppColor.bottomRed,
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
            label: 'Menu',
            icon: Icon(
              Icons.apps_outlined,
              color: _currentIndex == 0 ? AppColor.bottomRed : AppColor.white,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Playlist',
            icon: SvgPicture.asset(
              AppAssets.library,
              color: _currentIndex == 1 ? AppColor.bottomRed : AppColor.white,
            ),
          ),
          BottomNavigationBarItem(
            label: 'My Library',
            icon: SvgPicture.asset(
              AppAssets.playlist,
              height: 22,
              color: _currentIndex == 2 ? AppColor.bottomRed : AppColor.white,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Search',
            icon: SvgPicture.asset(
              AppAssets.search,
              color: _currentIndex == 3 ? AppColor.bottomRed : AppColor.white,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Setting',
            icon: SvgPicture.asset(
              AppAssets.setting,
              color: _currentIndex == 4 ? AppColor.bottomRed : AppColor.white,
            ),
          ),
        ],
      ),
    );
  }
}
