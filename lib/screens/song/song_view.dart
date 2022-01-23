import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/database/repository/song_repository.dart';
import 'package:mp3_music_converter/screens/song/song_view_screen.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/screens/song/provider/music_provider.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/bottom_playlist_indicator.dart';
import 'package:mp3_music_converter/widgets/drawer.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SongViewCLass extends StatefulWidget {
  int width;
  SongViewCLass(this.width);
  @override
  _SongViewCLassState createState() => _SongViewCLassState();
}

class _SongViewCLassState extends State<SongViewCLass> {
  MusicProvider _musicProvider;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController _scrollController;
  // Map<String, BannerAd> loadedAds = {};
  Timer _timer;
  final OnAudioQuery _audioquery = OnAudioQuery();
  bool showSync = false;
  int value = 0;
  int total = 0;

  @override
  void initState() {
    init();
    _scrollController = ScrollController();
    // startTimer();
    super.initState();
  }

  @override
  void dispose() {
    // loadedAds.values.forEach((element) {
    //   element?.dispose();
    // });
    _timer?.cancel();
    super.dispose();
  }

  init() async {
    _musicProvider = Provider.of<MusicProvider>(context, listen: false);
    await _musicProvider.getSongs();
    // createAd(widget.width);
  }

  // void startTimer() async {
  //   const time = const Duration(seconds: 10);
  //   _timer = new Timer.periodic(time, (timer) async {
  //     // createAd(widget.width);
  //     setState(() {});
  //   });
  // }

  //creates all ads that needs to be displayed. Enusure this is same as the number in the listview.separator
  // createAd(int width) {
  //   for (int i = 0; i < _musicProvider.allSongs.length; i++) {
  //     if ((i + 1) % 5 == 0) {
  //       if (loadedAds['appAd$i'] == null) {
  //         BannerAd ads = BannerAd(
  //           size: AdSize(width: width, height: 70),
  //           adUnitId: Platform.isAndroid
  //               ? 'ca-app-pub-4279408488674166/1078290794'
  //               : 'ca-app-pub-4279408488674166/6018640831',
  //           listener: BannerAdListener(
  //             onAdFailedToLoad: (ad, error) => ad?.dispose(),
  //             onAdLoaded: (ad) => setState(
  //               () {
  //                 loadedAds['appAd$i'] = ad as BannerAd;
  //               },
  //             ),
  //           ),
  //           request: AdRequest(),
  //         );
  //         ads.load();
  //       }
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawerEnableOpenDragGesture: false,
      backgroundColor: AppColor.white.withOpacity(0.05),
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              // _scrollController.jumpTo(24 + 186 + 85.0);
              // _scrollController.jumpTo(186.0 + (100 * 16) - 8 + (99 * 85));
              int index = _musicProvider.allSongs.indexWhere((song) =>
                  song.songName == _musicProvider.currentSong.songName);
              if (index == 0)
                _scrollController.animateTo(0,
                    duration: Duration(seconds: 1), curve: Curves.easeInOut);
              if (index == 1)
                _scrollController.animateTo(90,
                    duration: Duration(seconds: 1), curve: Curves.easeInOut);
              if (index != -1)
                _scrollController.animateTo(
                    ((index - 2).toDouble() * 85) + ((index - 1) * 16) + 178,
                    duration: Duration(seconds: 1),
                    curve: Curves.easeInOut);
            },
            child: Container(
              width: 30,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 15,
                    child: Icon(FontAwesomeIcons.caretUp, color: Colors.red),
                  ),
                  Icon(FontAwesomeIcons.caretDown, color: Colors.red),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.red[700],
                  ),
                ),
                onPressed: () {
                  synchronizeSong(context);
                },
                child: Text('Sync songs',
                    style: TextStyle(color: Colors.white, fontSize: 17))),
          )
        ],
        backgroundColor: AppColor.black,
        title: TextViewWidget(
          text: 'Song',
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
      ),
      endDrawer: Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
          child: AppDrawer()),
      body: Column(
        children: [
          Expanded(
            child: buildSongList(),
          ),
          BottomPlayingIndicator()
        ],
      ),
    );
  }

  Widget buildSongList() {
    return Consumer<MusicProvider>(builder: (_, _provider, __) {
      if (showSync) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 60,
              width: 60,
              child: CircularProgressIndicator(
                color: Colors.red,
                strokeWidth: 8,
                value: (value / total).toDouble(),
                // value: 0.3,
                backgroundColor: Colors.white24,
              ),
            ),
            SizedBox(height: 20),
            Text(
              '  ${((value / total).toDouble() * 100).round()}%',
              style: TextStyle(
                color: Colors.red,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            // SizedBox(height: 10),
            // Text(
            //   'Syncing',
            //   style: TextStyle(
            //     color: Colors.white,
            //     fontSize: 24,
            //   ),
            // )
          ],
        );
      }
      if (!showSync && _provider.allSongs.length < 1) {
        return Center(
            child: TextViewWidget(text: 'No Song', color: AppColor.white));
      }
      return Theme(
        data: Theme.of(context).copyWith(
          highlightColor: Colors.red,
          scrollbarTheme: ScrollbarThemeData(
            thumbColor: MaterialStateProperty.all<Color>(Colors.red),
            trackColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
        ),
        child: RawScrollbar(
          thumbColor: Colors.red,
          child: ListView.builder(
            itemCount: _provider.allSongs.length,
            controller: _scrollController,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              Song _song = _provider.allSongs[index];

              // if ((index + 1) % 5 == 0) {
              //   return Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       itemBuilder(song: _song, index: index, provider: _provider),
              //       if (_provider.allSongs.length - 1 != index)
              //         Padding(
              //           padding: const EdgeInsets.only(left: 115.0, right: 15),
              //           child: Divider(
              //             color: AppColor.white,
              //           ),
              //         ),
              //       // if (loadedAds['appAd$index'] != null)
              //       //   Container(
              //       //       child: AdWidget(ad: loadedAds['appAd$index']),
              //       //       alignment: Alignment.center,
              //       //       height: loadedAds['appAd$index'].size.height.toDouble(),
              //       //       width: loadedAds['appAd$index'].size.width.toDouble()),
              //       // if (loadedAds['appAd$index'] != null &&
              //       //     _provider.allSongs.length - 1 != index)
              //       //   Padding(
              //       //     padding: const EdgeInsets.only(left: 115.0, right: 15),
              //       //     child: Divider(
              //       //       color: AppColor.white,
              //       //     ),
              //       //   ),
              //     ],
              //   );
              // }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  itemBuilder(song: _song, index: index, provider: _provider),
                  if (_provider.allSongs.length - 1 != index)
                    Padding(
                      padding: const EdgeInsets.only(left: 115.0, right: 15),
                      child: Divider(
                        color: AppColor.white,
                      ),
                    ),
                  // if (_provider.allSongs.length == index + 1)
                  //   SizedBox(
                  //     height: 60,
                  //   )
                ],
              );
            },
          ),
        ),
      );
    });
  }

  Widget itemBuilder(
      {@required Song song,
      @required int index,
      @required MusicProvider provider}) {
    return Container(
      height: 85,
      child: ListTile(
        leading: SizedBox(
            width: 95,
            height: 150,
            child: song?.artWork != null && song.artWork.isNotEmpty
                ? Image.memory(song.artWork)
                : Image.asset('assets/new_icon.png')),
        title: GestureDetector(
          onTap: () async {
            _musicProvider.songs = _musicProvider.allSongs;
            _musicProvider.setCurrentIndex(index);
            int width = MediaQuery.of(context).size.width.floor();
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (_) => SongViewScreen(song, width),
              ),
            );
          },
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: TextViewWidget(
              text: song?.songName ?? 'Unknown',
              maxLines: 2,
              color: provider?.currentSong?.fileName == song?.fileName
                  ? AppColor.bottomRed
                  : AppColor.white,
              overflow: TextOverflow.ellipsis,
              textSize: 15,
              fontFamily: 'Roboto-Regular',
            ),
            subtitle: TextViewWidget(
              text: song?.artistName ?? 'Unknown Artist',
              color: provider?.currentSong?.fileName == song?.fileName
                  ? AppColor.bottomRed
                  : Colors.white60,
              textSize: 13,
              fontFamily: 'Roboto-Regular',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        trailing: InkWell(
          onTap: () {
            _musicProvider.updateDrawer(song);
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
    );
  }

  synchronizeSong(context) async {
    final status = await Permission.storage.request();

    if (status.isGranted) {
      SongRepository.clear();
      List<SongModel> songs = await _audioquery.querySongs();

      // print(songs[0].duration );
      if (mounted)
        setState(() {
          showSync = true;
          total = songs.length;
          value = 0;
        });

      for (int i = 0; i < songs.length; i++) {
        Uint8List artwork =
            await _audioquery.queryArtworks(songs[i].id, ArtworkType.AUDIO);

        if (songs[i].duration >= 60000 ?? false)
          await SongRepository.addSong(
            Song(
                artistName: songs[i].artist,
                fileName: songs[i].displayName,
                songName: songs[i].title,
                filePath: songs[i].fileParent,
                size: songs[i].size,
                artWork: artwork,
                musicid: songs[i].id.toString()),
          );
        if (mounted)
          setState(() {
            value = i + 1;
          });
      }
      if (mounted)
        setState(() {
          showSync = false;
          value = 0;
        });
      _musicProvider.getSongs();

      // String url = "http://67.205.165.56/api/mylib";
      // String token = await preferencesHelper.getStringValues(key: 'token');
      // MusicProvider _provider = Provider.of<MusicProvider>(context, listen: false);
      // _provider.getSongs();
      // final snackBar = SnackBar(
      //   content: Text('Failed to synchronize songs. Please try again later'),
      //   backgroundColor: Colors.red,
      // );

      // try {
      //   final response = await http.post(url,
      //       body: jsonEncode({'token': token}),
      //       headers: {'Content-Type': 'application/json'});

      //   if (response.statusCode == 200) {
      //     Map data = jsonDecode(response.body);
      //     List<Song> songs = _provider.allSongs;
      //     List<String> songTitle = [];
      //     Map<String, Map> songDetails = {};
      //     for (Map item in data['mainlib']) {
      //       songDetails.putIfAbsent(
      //           item['title'],
      //           () => {
      //                 'path': item['path'],
      //                 'image': item['image'][0] == "/"
      //                     ? "https://youtubeaudio.ca" + item['image']
      //                     : item['image'],
      //                 'libid': item['libid'],
      //                 'songName': item['songname'] ?? 'Unknown',
      //                 'artistName': item['artist'] ?? 'Unknown Artist',
      //                 'musicid': item['musicid'].toString()
      //               });
      //       for (Song song in songs) {
      //         if (item['title'] == song.fileName) {
      //           songTitle.add(song.fileName);
      //           break;
      //         }
      //       }
      //     }
      //     for (String title in songTitle) {
      //       songDetails.remove(title);
      //     }

      //     Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //             builder: (context) =>
      //                 Downloads(syncSongData: songDetails, syncSong: true)));
      //   } else
      //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // } catch (e) {
      //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // }
    } else
      showToast(context,
          message: 'You need to grant storage permission',
          backgroundColor: Colors.red,
          textColor: Colors.white);
  }
}
