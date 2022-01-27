import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/screens/split/provider/split_song_provider.dart';
import 'package:mp3_music_converter/screens/split/sing_along.dart';
import 'package:mp3_music_converter/screens/split/split.dart';
import 'package:mp3_music_converter/screens/split/split_song_drawer.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/bottom_playlist_indicator.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SplitScreen extends StatefulWidget {
  @override
  _SplitScreenState createState() => _SplitScreenState();
}

class _SplitScreenState extends State<SplitScreen> {
  SplitSongProvider _splitSongProvider;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Song selectedSong;
  RefreshController _refreshController = RefreshController();
  bool hideDisclaimer = false;

  @override
  void initState() {
    _splitSongProvider = Provider.of<SplitSongProvider>(context, listen: false);
    _splitSongProvider.getSongs(true);
    super.initState();
    getBoolDisclaimer();
  }

  _onRefresh() async {
    await _splitSongProvider.getSongs(true);
    _refreshController.refreshCompleted();
  }

  getBoolDisclaimer() async {
    bool exists =
        await preferencesHelper.doesExists(key: 'hideRecordDisclaimer');
    hideDisclaimer = exists
        ? await preferencesHelper.getBoolValues(key: 'hideRecordDisclaimer')
        : false;
  }

  toggleHideDisclaimer(bool val) {
    hideDisclaimer = val;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawerEnableOpenDragGesture: false,
      backgroundColor: AppColor.white.withOpacity(0.05),
      appBar: AppBar(
        backgroundColor: AppColor.black,
        title: TextViewWidget(
          text: 'Voiceover',
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
          Container(),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          //   child: TextButton(
          //       style: ButtonStyle(
          //           backgroundColor:
          //               MaterialStateProperty.all(Colors.red[700])),
          //       onPressed: () {
          //         synchronizeSplitSong(context);
          //       },
          //       child: Text('Sync split',
          //           style: TextStyle(color: Colors.white, fontSize: 17))),
          // )
        ],
      ),
      endDrawer: SplitSongDrawer(selectedSong, true),
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
    return Consumer<SplitSongProvider>(builder: (_, _provider, __) {
      if (_provider.allSongs.length < 1) {
        return Center(
            child:
                TextViewWidget(text: 'No Split Song', color: AppColor.white));
      }
      return SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: ListView.builder(
          itemCount: _provider.allSongs.length,
          itemBuilder: (BuildContext context, int index) {
            Song _song = _provider.allSongs[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    int width = MediaQuery.of(context).size.width.floor();
                    if (!hideDisclaimer)
                      splitDisclaimer(
                          context: context,
                          hideDisclaimer: hideDisclaimer,
                          toggleHideDisclaimer: toggleHideDisclaimer,
                          song: _song,
                          width: width,
                          muteAudio: false);
                    else
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => Split(
                            song: _song,
                            width: width,
                          ),
                        ),
                      );
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
                          : Image.asset('assets/log.png'),
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
                    trailing: GestureDetector(
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
        ),
      );
    });
  }
}

// synchronizeSplitSong(BuildContext context) async {
//   String url = "http://159.223.129.191/api/mylib";
//   String token = await preferencesHelper.getStringValues(key: 'token');
//   SplitSongProvider _provider =
//       Provider.of<SplitSongProvider>(context, listen: false);
//   _provider.getSongs(true);
//   final snackBar = SnackBar(
//     content: Text('Failed to synchronize songs. Please try again later'),
//     backgroundColor: Colors.red,
//   );

//   try {
//     final response = await http.post(url,
//         body: jsonEncode({'token': token}),
//         headers: {'Content-Type': 'application/json'});
//     if (response.statusCode == 200) {
//       Map data = jsonDecode(response.body);
//       print(data['sepratedsongs']);
//       List<Song> splitSongs = _provider.allSongs;
//       List<String> songTitle = [];
//       Map<String, Map> songDetails = {};

//       for (Map item in data['sepratedsongs']) {
//         String voice, others, image, musicid, artistName, songName;
//         int vocalid, othersid;
//         musicid = item['topsong']['musicid'].toString();
//         artistName = item['topsong']['artist'] ?? 'Unknown Artist';
//         songName = item['topsong']['songname'] ?? 'Unknown';

//         item['songs'].forEach((val) {
//           if (val['title'] == 'voice') {
//             voice = val['path'];
//             image = val['image'][0] == "/"
//                 ? "https://youtubeaudio.ca" + val['image']
//                 : val['image'];
//             vocalid = val['libid'];
//           } else if (val['title'] == 'others') {
//             others = val['path'];
//             othersid = val['libid'];
//           }
//         });
//         songDetails.putIfAbsent(
//             item['topsong']['title'],
//             () => {
//                   'voice': voice,
//                   'others': others,
//                   'image': image,
//                   'vocalid': vocalid,
//                   'othersid': othersid,
//                   'songName': songName,
//                   'artistName': artistName,
//                   'musicid': musicid
//                 });
//         for (Song song in splitSongs) {
//           if (item['topsong']['title'] == song.splitFileName) {
//             songTitle.add(song.splitFileName);
//             break;
//           }
//         }
//       }
//       for (String title in songTitle) {
//         songDetails.remove(title);
//       }

//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) =>
//                   Downloads(syncSplitData: songDetails, syncSplit: true)));
//     } else
//       ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }
// }
