import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/screens/world_radio/radio_class.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/widgets/bottom_playlist_indicator.dart';
import 'package:mp3_music_converter/widgets/red_background_backend/red_background2.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:provider/provider.dart';
import '../screens/song/provider/music_provider.dart';
import '../screens/song/song_view_screen.dart';
import '../utils/page_router/navigator.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<Song> songs = [];
  List<Song> songDuplicate = [];
  MusicProvider _musicProvider;
  String searchKeyword = '';
  bool searching = false;

  @override
  void initState() {
    _musicProvider = Provider.of<MusicProvider>(context, listen: false);
    _musicProvider.getSongs();
    songs.addAll(_musicProvider.allSongs);
    songDuplicate.addAll(songs);
    super.initState();
  }

  searchSong(String query) {
    List<Song> dummySearchList = [];
    dummySearchList.addAll(_musicProvider.allSongs);
    if (query.isNotEmpty) {
      List<Song> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.songName.toLowerCase().contains(query.toLowerCase()) ||
            item.artistName.toLowerCase().contains(query.toLowerCase()) &&
                !dummyListData.contains(item)) {
          dummyListData.add(item);
        }
      });
      songs.clear();
      songs.addAll(dummyListData);
      if (songs.length > 0)
        songs.sort((a, b) => a.songName.compareTo(b.songName));
      setState(() {});
      return;
    } else {
      songs.clear();
      songs.addAll(songDuplicate);
      if (songs.length > 0)
        songs.sort((a, b) => a.songName.compareTo(b.songName));
      setState(() {});
    }
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
    return Scaffold(
      body: Consumer<MusicProvider>(builder: (_, _provider, __) {
        return Container(
          color: AppColor.background,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RedBackground2(
                text: 'Search',
                openRadio: openRadio,
              ),
              Column(
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12, left: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColor.transparent,
                        border: Border.all(
                          color: AppColor.background1,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      margin: EdgeInsets.all(12),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Icon(
                              Icons.search,
                              color: AppColor.white,
                              size: 20,
                            ),
                          ),
                          new Expanded(
                            child: TextField(
                              onChanged: (s) {
                                setState(() {
                                  searching = true;
                                  searchKeyword = s;
                                });
                                searchSong(s);
                              },
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Search",
                                hintStyle: TextStyle(color: AppColor.white),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 12),
                                isDense: true,
                              ),
                              style: TextStyle(
                                fontSize: 14.0,
                                color: AppColor.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: ClipOval(
                              child: Material(
                                color: AppColor.transparent, // button color
                                child: InkWell(
                                  splashColor: AppColor.white, // inkwell color
                                  child: SizedBox(
                                      width: 36,
                                      height: 24,
                                      child: Icon(
                                        Icons.check,
                                        color: AppColor.white,
                                        size: 20,
                                      )),
                                  onTap: () {
                                    searchSong(searchKeyword);
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              songs.length > 0
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: songs.length,
                        itemBuilder: (BuildContext context, int index) {
                          Song _song = songs[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: SizedBox(
                                    width: 95,
                                    height: 150,
                                    child: _song?.image != null &&
                                            _song.image.isNotEmpty
                                        ? CachedNetworkImage(
                                            imageUrl: _song.image,
                                            placeholder: (context, index) =>
                                                Container(
                                              child: Center(
                                                  child: SizedBox(
                                                      width: 20,
                                                      height: 20,
                                                      child:
                                                          CircularProgressIndicator())),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    new Icon(Icons.error),
                                          )
                                        : null),
                                title: InkWell(
                                  onTap: () {
                                    _musicProvider.songs =
                                        _musicProvider.allSongs;
                                    int width = MediaQuery.of(context)
                                        .size
                                        .width
                                        .floor();
                                    PageRouter.gotoWidget(
                                        SongViewScreen(_song, width), context);
                                  },
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: TextViewWidget(
                                      text: _song?.songName ?? 'Unknown',
                                      color: _provider?.currentSong?.fileName ==
                                              _song?.fileName
                                          ? AppColor.bottomRed
                                          : AppColor.white,
                                      textSize: 15,
                                      fontFamily: 'Roboto-Regular',
                                    ),
                                    subtitle: TextViewWidget(
                                      text:
                                          _song?.artistName ?? 'Unknown Artist',
                                      color: _provider?.currentSong?.fileName ==
                                              _song?.fileName
                                          ? AppColor.bottomRed
                                          : AppColor.white,
                                      textSize: 13,
                                      fontFamily: 'Roboto-Regular',
                                    ),
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.navigate_next_sharp,
                                  color: AppColor.white,
                                ),
                              ),
                              if (songs.length - 1 != index)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 115.0, right: 15),
                                  child: Divider(
                                    color: AppColor.white,
                                  ),
                                )
                            ],
                          );
                        },
                      ),
                    )
                  : Expanded(
                      child: Center(
                        child: Text(
                          searching ? 'No match found' : 'No Song',
                          style: TextStyle(
                            color: AppColor.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
              BottomPlayingIndicator(),
            ],
          ),
        );
      }),
    );
  }
}
