import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/screens/dashboard/main_dashboard.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/bottom_playlist_indicator.dart';
import 'package:mp3_music_converter/widgets/drawer.dart';
import 'package:mp3_music_converter/widgets/red_background.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:provider/provider.dart';

import '../screens/song/provider/music_provider.dart';
import '../screens/song/song_view_screen.dart';
import '../utils/page_router/navigator.dart';

class PlayListView extends StatefulWidget {
  final String playListName;
  PlayListView(this.playListName);
  @override
  _PlayListViewState createState() => _PlayListViewState();
}

class _PlayListViewState extends State<PlayListView> {
  MusicProvider _musicProvider;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Song> _song = [];

  void getSong() async {
    _musicProvider = Provider.of<MusicProvider>(context);
    await _musicProvider.getSongs();
    await _musicProvider.getPlayListSongTitle(widget.playListName);
    List<Song> localSong = [];
    List songTitle = _musicProvider.playListSongTitle;
    List<Song> allSongs = _musicProvider.allSongs;
    for (Song song in allSongs) {
      for (String name in songTitle) {
        if (song.fileName == name) localSong.add(song);
      }
    }
    _song = localSong;
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    getSong();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.black,
        title: TextViewWidget(
          text: widget.playListName,
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
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: buildSongList(),
            ),
            BottomPlayingIndicator()
          ],
        ),
      ),
    );
  }

  Widget buildSongList() {
    if (_song.length < 1) {
      return Center(
          child: TextViewWidget(text: 'No Song', color: AppColor.white));
    }
    return ListView.builder(
      itemCount: _song.length,
      itemBuilder: (BuildContext context, int index) {
        Song _currentSong = _song[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: SizedBox(
                  width: 95,
                  height: 150,
                  child: _currentSong?.image != null &&
                          _currentSong.image.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: _currentSong.image,
                          placeholder: (context, index) => Container(
                            child: Center(
                                child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator())),
                          ),
                          errorWidget: (context, url, error) =>
                              new Icon(Icons.error),
                        )
                      : null),
              title: GestureDetector(
                onTap: () async {
                  _musicProvider.songs = _song;
                  _musicProvider.setCurrentIndex(index);
                  PageRouter.gotoWidget(SongViewScreen(_currentSong), context);
                },
                child: TextViewWidget(
                  text: _currentSong?.fileName ?? '',
                  color: AppColor.white,
                  textSize: 15,
                  fontFamily: 'Roboto-Regular',
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
                    color: AppColor.white,
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
    );
  }
}
