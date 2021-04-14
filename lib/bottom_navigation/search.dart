import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/bottom_playlist_indicator.dart';
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

  @override
  void initState() {
    _musicProvider = Provider.of<MusicProvider>(context, listen: false);
    _musicProvider.getSongs();
    songs.addAll(_musicProvider.allSongs);
    songDuplicate.addAll(songs);
    super.initState();
  }

  searchSong(String query){
    List<Song> dummySearchList = [];
    dummySearchList.addAll(songs);
    if (query.isNotEmpty) {
      List<Song> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.fileName.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      songs.clear();
      songs.addAll(dummyListData);
      if (songs.length > 0) songs.sort((a, b) => a.fileName.compareTo(b.fileName));
      setState(() {});
      return;
    } else {
      songs.clear();
      songs.addAll(songDuplicate);
      if (songs.length > 0) songs.sort((a, b) => a.fileName.compareTo(b.fileName));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MusicProvider>(
          builder: (_, _provider, __) {
            if(songs.length < 1){
              songs.addAll(_provider.allSongs);
              songDuplicate.addAll(songs);
            }
          return Container(
            color: AppColor.background,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Image.asset(AppAssets.rect),
                    Column(
                      children: [
                        SizedBox(height: 65),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(AppAssets.logo),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipOval(
                                  child: Image.asset('assets/burna.png'),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: TextViewWidget(
                                        color: AppColor.white,
                                        text: 'Profile',
                                        textSize: 17,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Montserrat-Thin')),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
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
                                    onTap: () {},
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
                Expanded(
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
                                  errorWidget: (context, url, error) =>
                                  new Icon(Icons.error),
                                )
                                    : null),
                            title: InkWell(
                              onTap: () {
                                _musicProvider.songs = _musicProvider.allSongs;
                                PageRouter.gotoWidget(SongViewScreen(_song), context);
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
                          if(songs.length - 1 != index)
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
                  ),
                ),
                BottomPlayingIndicator(),
              ],
            ),
          );
        }
      ),
    );
  }
}
