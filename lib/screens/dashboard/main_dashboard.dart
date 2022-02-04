import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mp3_music_converter/bottom_navigation/my_library.dart';
import 'package:mp3_music_converter/bottom_navigation/playlist.dart';
import 'package:mp3_music_converter/bottom_navigation/search.dart';
import 'package:mp3_music_converter/bottom_navigation/setting.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/screens/bookworm/provider/bookworm_provider.dart';
import 'package:mp3_music_converter/screens/dashboard/dashboard.dart';
import 'package:mp3_music_converter/screens/recorded/provider/record_provider.dart';
import 'package:mp3_music_converter/screens/song/provider/music_provider.dart';
import 'package:mp3_music_converter/screens/split/provider/split_song_provider.dart';
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
  SplitSongProvider _repository;
  RecordProvider _recordProvider;
  BookwormProvider _bookwormProvider;
  List<Widget> _screens;

  @override
  void initState() {
    // LinkShareAssistant()
    //   ..onDataReceived = _handleSharedData
    //   ..getSharedData().then(_handleSharedData);
    init();

    _screens = [DashBoard(), PlayList(), Library(), Search(), Setting()];
    super.initState();
  }

  // void _handleSharedData(String sharedData) {
  //   print('sharedData is $sharedData');
  //   MusicProvider _provider =
  //       Provider.of<MusicProvider>(context, listen: false);
  //   if (sharedData != null &&
  //       sharedData.isNotEmpty &&
  //       _provider.sharedText != sharedData) {
// _provider.updateCurrentIndex(0);
  //   }
  // }

  init() async {
    _musicProvider = Provider.of<MusicProvider>(context, listen: false);
    await _musicProvider.initProvider();
    _repository = Provider.of<SplitSongProvider>(context, listen: false);
    _repository.initProvider();
    _recordProvider = Provider.of<RecordProvider>(context, listen: false);
    await _recordProvider.initProvider();
    _bookwormProvider = Provider.of<BookwormProvider>(context, listen: false);
    _bookwormProvider.initProvider();
    if (AudioService.queue == null || AudioService.queue.isEmpty) {
      if (await preferencesHelper.doesExists(key: 'last_play_queue'))
        preferencesHelper
            .getStringList(key: 'last_play_queue')
            .then((value) async {
          List<Song> songList = [];
          Song song;
          List lastPlayQueue = value;
          await _musicProvider.getSongs();
          for (String name in lastPlayQueue) {
            song = _musicProvider.allSongs
                .firstWhere((element) => element.musicid == name);
            songList.add(song);
          }
          _musicProvider.songs = songList;
          // List<MediaItem> songResult =
          //     _musicProvider.convertSongToMediaItem(songList);
          // AudioService.updateQueue(songResult);
        });
      if (await preferencesHelper.doesExists(key: 'last_play'))
        preferencesHelper.getCachedData(key: 'last_play').then((value) async {
          // Map queue =
          //     await preferencesHelper.getCachedData(key: 'last_play_queue');
          // if (queue != null) {
          //   print(queue);
          // List<Song> songList = queue.values.map((e) => Song.fromMap(e));
          // _musicProvider.songs = songList;
          // }
          if (value != null) {
            MediaItem item = MediaItem(
                album: value['title'],
                id: value['id'],
                title: value['title'],
                artist: value['artist'],
                extras: {
                  'fileName': value['fileName'],
                  'filePath': value['filePath'],
                  'image': value['image'],
                  'favourite': value['favorite']
                });

            _musicProvider.updateLocal(item);
          }
        }).catchError((error) {
          print(error);
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    _currentIndex = Provider.of<MusicProvider>(context).currentNavBarIndex;
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
          Provider.of<MusicProvider>(context, listen: false)
              .updateCurrentIndex(value);
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
