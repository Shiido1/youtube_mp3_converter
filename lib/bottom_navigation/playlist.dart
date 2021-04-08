import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/screens/create_playlist.dart';
import 'package:mp3_music_converter/screens/dashboard/main_dashboard.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/widgets/bottom_playlist_indicator.dart';
import 'package:mp3_music_converter/widgets/red_background.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:provider/provider.dart';

import '../screens/song/provider/music_provider.dart';
import '../screens/song/song_view_screen.dart';
import '../utils/page_router/navigator.dart';

class PlayList extends StatefulWidget {
  final String playListName;
  PlayList({this.playListName});

  @override
  _PlayListState createState() => _PlayListState();
}

class _PlayListState extends State<PlayList> {
  MusicProvider _musicProvider;

  void openPlaylist({String title}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlayList(
          playListName: title,
        ),
      ),
    );
  }

  @override
  void initState() {
    _musicProvider = Provider.of<MusicProvider>(context, listen: false);
    _musicProvider.getPlayLists();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: Column(
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
            text: 'Playlist',
          ),
          Expanded(child: Consumer<MusicProvider>(
            builder: (_, _provider, __) {
              if (_provider.playLists.length == 0) {
                return Center(
                    child:
                        TextViewWidget(text: 'No Song', color: AppColor.white));
              }
              return ListView.builder(
                itemCount: _provider.playLists.length,
                itemBuilder: (BuildContext context, int index) {
                  Song _song = _provider.playLists[index];
                  // int songCount = index > 0
                  //     ? _provider.playList[index]['songs'].length
                  //     : null;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // if (_provider.playList[index]['name'] ==
                          //     'Create playlist') {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CreatePlayList(
                                createNewPlaylist: true,
                              );
                            },
                          );
                          // } else {
                          //   openPlaylist(
                          //       title: _provider.playList[index]['name']);
                          // }
                        },
                        child: ListTile(
                          leading: Icon(
                            Icons.add_box,
                            size: 65,
                            color: AppColor.white,
                          ),
                          title: TextViewWidget(
                            color: AppColor.white,
                            text: "Create New Playlist",
                            textSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      ListTile(
                        leading: SizedBox(
                            width: 95,
                            height: 150,
                            child: _song?.image != null &&
                                    _song.image.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: _song?.image ?? '',
                                    placeholder: (context, index) => Container(
                                      child: Center(
                                          child: SizedBox(
                                              width: 20,
                                              height: 20,
                                              child:
                                                  CircularProgressIndicator())),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        new Icon(Icons.error),
                                  )
                                : null),
                        title: InkWell(
                          onTap: () {
                            _musicProvider.songs = _musicProvider.playLists;
                            PageRouter.gotoWidget(
                                SongViewScreen(_song), context);
                          },
                          child: TextViewWidget(
                            text: _song?.fileName ?? '',
                            color: AppColor.white,
                            textSize: 15,
                            fontFamily: 'Roboto-Regular',
                          ),
                        ),
                        trailing: Icon(
                          Icons.navigate_next_sharp,
                          color: AppColor.white,
                        ),
                      ),
                      if (_provider.playLists.length - 1 != index)
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 115.0, right: 15),
                          child: Divider(
                            color: AppColor.white,
                          ),
                        )
                    ],
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
