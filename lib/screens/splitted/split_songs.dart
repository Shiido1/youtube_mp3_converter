import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/screens/downloads/downloads.dart';
import 'package:mp3_music_converter/screens/splitted/provider/splitted_song_provider.dart';
import 'package:mp3_music_converter/screens/splitted/split.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/bottom_playlist_indicator.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:provider/provider.dart';
import 'package:mp3_music_converter/screens/splitted/delete_song.dart';
import 'package:http/http.dart' as http;

class SplittedScreen extends StatefulWidget {
  @override
  _SplittedScreenState createState() => _SplittedScreenState();
}

class _SplittedScreenState extends State<SplittedScreen> {
  SplittedSongProvider _splitSongProvider;

  @override
  void initState() {
    _splitSongProvider =
        Provider.of<SplittedSongProvider>(context, listen: false);
    _splitSongProvider.getSongs(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.black,
        title: TextViewWidget(
          text: 'Split Songs',
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
                  synchronizeSong(context);
                },
                child: Text('Synchronize',
                    style: TextStyle(color: Colors.white, fontSize: 17))),
          )
        ],
      ),
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
            child: TextViewWidget(
                text: 'No Splitted Song', color: AppColor.white));
      }
      return ListView.builder(
        itemCount: _provider.allSongs.length,
        itemBuilder: (BuildContext context, int index) {
          Song _song = _provider.allSongs[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onLongPress: () {
                  DeleteSongs(context).showDeleteDialog(
                      song: _song, splitted: true, showAll: true);
                },
                onTap: () {
                  int width = MediaQuery.of(context).size.width.floor();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => Split(
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
                          : null),
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
                  trailing: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      AppAssets.record,
                      color: AppColor.white,
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

synchronizeSong(BuildContext context) async {
  String url = "http://67.205.165.56/api/mylib";
  String token = await preferencesHelper.getStringValues(key: 'token');
  SplittedSongProvider _provider =
      Provider.of<SplittedSongProvider>(context, listen: false);
  _provider.getSongs(true);
  List<String> apiList = ['', ''];
  final snackBar = SnackBar(
    content: Text('Failed to synchronize songs. Please try again later'),
    backgroundColor: Colors.red,
  );

  try {
    final response = await http.post(url,
        body: jsonEncode({'token': token}),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      // List<Song> splitSongs = _provider.allSongs;
      List<Song> splitSongs = [Song(splittedFileName: '')];
      List<String> songTitle = [];
      Map<String, Map> songDetails = {};
      for (Map item in data['sepratedsongs']) {
        String voice, others, image;
        int libid;
        item['songs'].forEach((val) {
          if (val['title'] == 'voice') {
            voice = val['path'];
            image = val['image'];
          }
          if (val['title'] == 'others') others = val['path'];
        });
        songDetails.putIfAbsent(
            item['topsong']['title'],
            () => {
                  'voice': voice,
                  'others': others,
                  'image': image,
                  'libid': libid
                });
        for (Song song in splitSongs) {
          if (item['topsong']['title'] == song.splittedFileName) {
            songTitle.add(song.splittedFileName);
            break;
          }
        }
      }
      for (String title in songTitle) {
        songDetails.remove(title);
      }

      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) =>
      //             Downloads(syncData: songDetails, sync: true)));
    } else
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
