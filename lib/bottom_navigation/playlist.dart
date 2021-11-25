import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/database/repository/song_repository.dart';
import 'package:mp3_music_converter/playlist/create_playlist_screen.dart';
import 'package:mp3_music_converter/playlist/playlist_view.dart';
import 'package:mp3_music_converter/screens/song/provider/music_provider.dart';
import 'package:mp3_music_converter/screens/world_radio/radio_class.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/page_router/navigator.dart';
import 'package:mp3_music_converter/widgets/bottom_playlist_indicator.dart';
import 'package:mp3_music_converter/widgets/red_background_backend/red_background2.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:provider/provider.dart';

class PlayList extends StatefulWidget {
  @override
  _PlayListState createState() => _PlayListState();
}

class _PlayListState extends State<PlayList> {
  MusicProvider _musicProvider;
  List playlistImage = [];

  void getPlaylistImage() async {
    _musicProvider = Provider.of<MusicProvider>(context);
    _musicProvider.getSongs();
    _musicProvider.getPlayListNames();
    List<Song> allSongs = _musicProvider.allSongs;
    List songImages = [];
    for (int i = 0; i < _musicProvider.playLists.length; i++) {
      await _musicProvider.getPlayListSongTitle(_musicProvider.playLists[i]);
      _musicProvider.playListSongTitle.sort((a, b) {
        return a.toString().toLowerCase().compareTo(b.toString().toLowerCase());
      });
      if (_musicProvider.playListSongTitle.length > 1 &&
          _musicProvider.playListSongTitle[0] == null) {
        for (Song song in allSongs)
          if (song.musicid == _musicProvider.playListSongTitle[1])
            songImages.add(song.artWork);
      }
      if (_musicProvider.playListSongTitle.length > 0 &&
          _musicProvider.playListSongTitle[0] != null) {
        for (Song song in allSongs)
          if (song.musicid == _musicProvider.playListSongTitle[0])
            songImages.add(song.artWork);
      }
      if (_musicProvider.playListSongTitle.length == 1 &&
          _musicProvider.playListSongTitle[0] == null) {
        songImages.add(null);
      }
    }
    playlistImage = songImages;
  }

  void openRadio(String search) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RadioClass(
          search: search,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    getPlaylistImage();
    return Scaffold(
      backgroundColor: AppColor.background,
      body: Column(
        children: [
          RedBackground2(
            text: 'Playlist',
            openRadio: openRadio,
          ),
          InkWell(
            onTap: () async {
              createPlayListScreen(
                  context: context,
                  showToastMessage: true,
                  message: 'Playlist created');
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 28, vertical: 8.0),
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    color: Color.fromRGBO(196, 196, 196, 1),
                    child: Icon(Icons.add, size: 35),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      constraints: BoxConstraints(minHeight: 40),
                      width: MediaQuery.of(context).size.width,
                      child: TextViewWidget(
                          text: 'New Playlist...',
                          color: AppColor.white,
                          textSize: 18,
                          fontFamily: 'Roboto-Regular'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              height: 0,
              color: AppColor.white,
            ),
          ),
          Expanded(child: Consumer<MusicProvider>(
            builder: (_, _provider, __) {
              return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _provider.playLists.length,
                itemBuilder: (BuildContext context, int index) {
                  List playlist = _provider.playLists;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () async {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (_) => PlayListView(
                                    playListName: playlist[index],
                                    playlistImage: playlistImage[index]),
                              ),
                            );
                          },
                          onLongPress: () async {
                            await showPlayListOptions(
                                context: context,
                                playListName: playlist[index]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(196, 196, 196, 1),
                                      borderRadius: BorderRadius.circular(4)),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: playlistImage != null &&
                                              playlistImage.isNotEmpty &&
                                              playlistImage[index] != null
                                          ? Image.memory(playlistImage[index])
                                          : Image.asset('assets/new_icon.png')),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: Container(
                                    constraints: BoxConstraints(minHeight: 40),
                                    width: MediaQuery.of(context).size.width,
                                    child: TextViewWidget(
                                        text: playlist[index].toString() ?? '',
                                        color: AppColor.white,
                                        textSize: 18,
                                        fontFamily: 'Roboto-Regular'),
                                  ),
                                ),
                                Icon(
                                  Icons.navigate_next_sharp,
                                  color: AppColor.white,
                                  size: 30,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_provider.playLists.length - 1 != index)
                          Divider(
                            height: 0,
                            color: AppColor.white,
                          )
                      ],
                    ),
                  );
                },
              );
            },
          )),
          BottomPlayingIndicator()
        ],
      ),
    );
  }
}

Future<Widget> showPlayListOptions(
    {BuildContext context, String playListName}) {
  return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Color.fromRGBO(40, 40, 40, 1),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    PageRouter.goBack(context);
                    createPlayListScreen(
                        showToastMessage: true,
                        context: context,
                        message: 'Rename successful',
                        renamePlayList: true,
                        oldPlayListName: playListName);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        SizedBox(width: 20),
                        Text(
                          'Rename Playlist',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    PageRouter.goBack(context);
                    confirmDelete(playListName: playListName, context: context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_forever,
                          color: Colors.white,
                        ),
                        SizedBox(width: 20),
                        Text(
                          'Delete Playlist',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

Future<Widget> confirmDelete({BuildContext context, String playListName}) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromRGBO(40, 40, 40, 1),
          content: Text(
            'Do you want to delete this playlist?',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  PageRouter.goBack(context);
                },
                child: Text('NO',
                    style: TextStyle(
                      color: Color.fromRGBO(216, 19, 37, 1),
                    ))),
            TextButton(
                onPressed: () {
                  SongRepository.deletePlayList(playListName);
                  PageRouter.goBack(context);
                },
                child: Text(
                  'YES',
                  style: TextStyle(
                    color: Color.fromRGBO(216, 19, 37, 1),
                  ),
                )),
          ],
        );
      });
}
