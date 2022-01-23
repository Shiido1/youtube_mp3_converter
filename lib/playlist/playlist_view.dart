import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/bottom_playlist_indicator.dart';
import 'package:mp3_music_converter/widgets/drawer.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../screens/song/provider/music_provider.dart';
import '../screens/song/song_view_screen.dart';
import '../utils/page_router/navigator.dart';

class PlayListView extends StatefulWidget {
  final String playListName;
  final playlistImage;
  PlayListView({this.playListName, this.playlistImage});
  @override
  _PlayListViewState createState() => _PlayListViewState();
}

class _PlayListViewState extends State<PlayListView> {
  MusicProvider _musicProvider;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Song> _song = [];
  Song _currentlyPlayingSong;
  bool isFavorite = false;
  bool shuffle;
  bool repeat;

  checkFavorite() {
    List fave = [];
    _song.forEach((element) {
      fave.add(element.favorite);
    });
    isFavorite = !fave.contains(false);
  }

  void getPlaylistSongDetails() async {
    _musicProvider = Provider.of<MusicProvider>(context);
    await _musicProvider.getSongs();
    await _musicProvider.getPlayListSongTitle(widget.playListName);
    List<Song> localSong = [];
    List songTitle = _musicProvider.playListSongTitle;
    List<Song> allSongs = _musicProvider.allSongs;
    for (Song song in allSongs) {
      for (String name in songTitle) {
        if (song.musicid == name) localSong.add(song);
      }
    }
    _song = localSong;
    _currentlyPlayingSong = _musicProvider.currentSong;
    shuffle = _musicProvider.shuffleSong;
    repeat = _musicProvider.repeatSong;
    checkFavorite();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getPlaylistSongDetails();
    return Scaffold(
      key: _scaffoldKey,
      endDrawerEnableOpenDragGesture: false,
      backgroundColor: AppColor.white.withOpacity(0.05),
      appBar: AppBar(
        actions: [Container()],
        backgroundColor: AppColor.black,
        title: TextViewWidget(
          text: 'Playlist',
          color: AppColor.bottomRed,
        ),
        leading: IconButton(
          onPressed: () {
            PageRouter.goBack(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: AppColor.bottomRed,
          ),
        ),
      ),
      endDrawer: Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
          child: AppDrawer()),
      body: Theme(
        data: Theme.of(context).copyWith(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent),
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: buildSongList(),
              ),
              BottomPlayingIndicator()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSongList() {
    if (_song.length < 1) {
      return Center(
          child: TextViewWidget(text: 'No Song', color: AppColor.white));
    }
    return ListView(
      children: [
        SizedBox(height: 10),
        Center(
          child: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
                color: Color.fromRGBO(196, 196, 196, 1),
                borderRadius: BorderRadius.circular(10)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: _song[0].artWork != null && _song[0].artWork.isNotEmpty
                  ? Image.memory(_song[0].artWork)
                  : Image.asset('assets/new_icon.png'),
            ),
          ),
        ),
        SizedBox(height: 10),
        Center(
            child: Text(
          widget.playListName,
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
        )),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                checkFavorite();
                _song.forEach((element) {
                  _musicProvider.updateSong(element..favorite = !isFavorite);
                });
              },
              child: Column(
                children: [
                  SvgPicture.asset(
                    AppAssets.favorite,
                    height: 20.8,
                    color: isFavorite ? AppColor.red : AppColor.white,
                  ),
                  TextViewWidget(
                    text: 'Favorite',
                    color: AppColor.white,
                  )
                ],
              ),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                shuffle
                    ? _musicProvider.stopShuffle()
                    : _musicProvider.shuffle(false);
                // PageRouter.gotoWidget(SongViewScreen(_song[_musicProvider.currentIndex]), context);
              },
              child: Column(
                children: [
                  SvgPicture.asset(AppAssets.shuffle,
                      color: shuffle ? AppColor.bottomRed : AppColor.white),
                  TextViewWidget(text: 'Shuffle', color: AppColor.white)
                ],
              ),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () {
                repeat
                    ? _musicProvider.undoRepeat()
                    : _musicProvider.repeat(_musicProvider.drawerItem);
              },
              child: Column(
                children: [
                  SvgPicture.asset(
                    AppAssets.repeat,
                    color: repeat ? AppColor.bottomRed : AppColor.white,
                  ),
                  TextViewWidget(text: 'Repeat', color: AppColor.white)
                ],
              ),
            ),
            SizedBox(width: 15),
            InkWell(
              onTap: () async {
                Share.shareFiles(_song
                    .map((element) =>
                        File('${element.filePath}/${element.fileName}').path)
                    .toList());
              },
              child: Column(
                children: [
                  SvgPicture.asset(AppAssets.share),
                  TextViewWidget(text: 'Share', color: AppColor.white)
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                _musicProvider.stopShuffle();
                _musicProvider.setCurrentIndex(0);
                int width = MediaQuery.of(context).size.width.floor();
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => SongViewScreen(_song[0], width),
                  ),
                );
              },
              child: Container(
                height: 40,
                width: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(234, 113, 98, 1),
                    borderRadius: BorderRadius.circular(14)),
                child: Text(
                  'Play',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 18),
                ),
              ),
            ),
            SizedBox(width: 30),
            InkWell(
              onTap: () {
                _musicProvider.shuffle(true);
              },
              child: Container(
                height: 40,
                width: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    borderRadius: BorderRadius.circular(14)),
                child: Text(
                  'Shuffle',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 18),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Divider(
            height: 10,
            color: Color.fromRGBO(80, 80, 80, 1),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: _song.length,
          itemBuilder: (BuildContext context, int index) {
            Song _currentSong = _song[index];
            _musicProvider.songs = _song;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: SizedBox(
                      width: 95,
                      height: 150,
                      child: _currentSong?.artWork != null &&
                              _currentSong.artWork.isNotEmpty
                          ? Image.memory(_currentSong?.artWork)
                          : Image.asset('assets/new_icon.png')),
                  title: GestureDetector(
                    onTap: () async {
                      _musicProvider.songs = _song;
                      _musicProvider.setCurrentIndex(index);
                      int width = MediaQuery.of(context).size.width.floor();
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => SongViewScreen(_currentSong, width),
                        ),
                      );
                    },
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: TextViewWidget(
                        text: _currentSong?.songName ?? 'Unknown',
                        color: _currentlyPlayingSong?.fileName ==
                                _currentSong?.fileName
                            ? AppColor.bottomRed
                            : AppColor.white,
                        textSize: 15,
                        fontFamily: 'Roboto-Regular',
                      ),
                      subtitle: TextViewWidget(
                        text: _currentSong?.artistName ?? 'Unknown Artist',
                        color: _currentlyPlayingSong?.fileName ==
                                _currentSong?.fileName
                            ? AppColor.bottomRed
                            : AppColor.white,
                        textSize: 13,
                        fontFamily: 'Roboto-Regular',
                      ),
                    ),
                  ),
                  trailing: InkWell(
                    onTap: () {
                      _musicProvider.updateDrawer(_currentSong);
                      _scaffoldKey.currentState.openEndDrawer();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        AppAssets.dot,
                        color: _currentlyPlayingSong?.fileName ==
                                _currentSong?.fileName
                            ? AppColor.bottomRed
                            : AppColor.white,
                      ),
                    ),
                  ),
                ),
                if (_song.length - 1 != index)
                  Padding(
                    padding: const EdgeInsets.only(left: 115.0, right: 15),
                    child: Divider(
                      color: AppColor.white,
                    ),
                  )
              ],
            );
          },
        ),
      ],
    );
  }
}
