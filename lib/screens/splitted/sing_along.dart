import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/screens/splitted/provider/splitted_song_provider.dart';
import 'package:mp3_music_converter/screens/splitted/split_song_drawer.dart';
import 'package:mp3_music_converter/screens/splitted/split_songs.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/bottom_playlist_indicator.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:provider/provider.dart';
import 'package:mp3_music_converter/screens/splitted/mute_vocal_song_screen.dart';

class SingAlong extends StatefulWidget {
  @override
  _SingAlongState createState() => _SingAlongState();
}

class _SingAlongState extends State<SingAlong> {
  SplittedSongProvider _songProvider;
  Song selectedSong;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _songProvider = Provider.of<SplittedSongProvider>(context, listen: false);
    _songProvider.getSongs(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.black,
        title: TextViewWidget(
          text: 'Sing Along',
          color: AppColor.bottomRed,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: AppColor.bottomRed,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue)),
                onPressed: () {
                  synchronizeSplitSong(context);
                },
                child: Text('Sync split',
                    style: TextStyle(color: Colors.white, fontSize: 17))),
          )
        ],
      ),
      endDrawer: SplitSongDrawer(selectedSong, false),
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
    return Consumer<SplittedSongProvider>(builder: (_, _provider, __) {
      if (_provider.allSongs.length < 1) {
        return Center(
            child: TextViewWidget(text: 'No Song', color: AppColor.white));
      }
      return ListView.builder(
        itemCount: _provider.allSongs.length,
        itemBuilder: (BuildContext context, int index) {
          Song _song = _provider.allSongs[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                // onLongPress: () {
                //   DeleteSongs(context).showDeleteDialog(
                //       song: _song, splitted: true, showAll: false);
                // },
                onTap: () {
                  int width = MediaQuery.of(context).size.width.floor();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => MuteVocalsScreen(
                                song: _song,
                                width: width,
                              )));
                },
                child: ListTile(
                  leading: SizedBox(
                    width: 95,
                    height: 150,
                    child: _song?.image != null && _song.image.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: _song.image,
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
                        : Container(
                            color: Colors.white,
                            alignment: Alignment.center,
                            child: Text(
                              _song.songName[0].toUpperCase() ?? 'U',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 45,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                  ),
                  title: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: TextViewWidget(
                      text: _song?.songName ?? 'Unknown',
                      color: AppColor.white,
                      textSize: 15,
                      fontFamily: 'Roboto-Regular',
                    ),
                    subtitle: TextViewWidget(
                      text: _song?.artistName ?? 'Unknown Artist',
                      color: AppColor.white,
                      textSize: 13,
                      fontFamily: 'Roboto-Regular',
                    ),
                  ),
                  trailing: InkWell(
                    onTap: () {
                      setState(() {
                        selectedSong = _song;
                      });
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
              ),
              if (_provider.allSongs.length - 1 != index)
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
    });
  }
}
