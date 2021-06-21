import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/screens/song/song_view_screen.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/screens/song/provider/music_provider.dart';
import 'package:mp3_music_converter/utils/page_router/navigator.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/bottom_playlist_indicator.dart';
import 'package:mp3_music_converter/widgets/drawer.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
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
  Map<String, BannerAd> loadedAds = {};
  Timer _timer;

  @override
  void initState() {
    init();
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    loadedAds.values.forEach((element) {
      element?.dispose();
    });
    _timer?.cancel();
    super.dispose();
  }

  init() async {
    _musicProvider = Provider.of<MusicProvider>(context, listen: false);
    await _musicProvider.getSongs();
    createAd(widget.width);
  }

  void startTimer() async {
    const time = const Duration(seconds: 10);
    _timer = new Timer.periodic(time, (timer) async {
      createAd(widget.width);
      setState(() {});
    });
  }

  //creates all ads that needs to be displayed. Enusure this is same as the number in the listview.separator
  createAd(int width) {
    for (int i = 0; i < _musicProvider.allSongs.length; i++) {
      if ((i + 1) % 5 == 0) {
        if (loadedAds['appAd$i'] == null) {
          BannerAd ads = BannerAd(
            size: AdSize(width: width, height: 70),
            adUnitId: Platform.isAndroid
                ? 'ca-app-pub-4279408488674166/9228377666'
                : 'ca-app-pub-4279408488674166/6018640831',
            listener: BannerAdListener(
              onAdFailedToLoad: (ad, error) => ad?.dispose(),
              onAdLoaded: (ad) => setState(
                () {
                  loadedAds['appAd$i'] = ad as BannerAd;
                },
              ),
            ),
            request: AdRequest(),
          );
          ads.load();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColor.background,
      appBar: AppBar(
        // actions: [Container()],
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
    return Consumer<MusicProvider>(builder: (_, _provider, __) {
      if (_provider.allSongs.length < 1) {
        return Center(
            child: TextViewWidget(text: 'No Song', color: AppColor.white));
      }
      return ListView.builder(
        itemCount: _provider.allSongs.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          Song _song = _provider.allSongs[index];

          if ((index + 1) % 5 == 0) {
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
                if (loadedAds['appAd$index'] != null)
                  Container(
                      child: AdWidget(ad: loadedAds['appAd$index']),
                      alignment: Alignment.center,
                      height: loadedAds['appAd$index'].size.height.toDouble(),
                      width: loadedAds['appAd$index'].size.width.toDouble()),
                if (loadedAds['appAd$index'] != null &&
                    _provider.allSongs.length - 1 != index)
                  Padding(
                    padding: const EdgeInsets.only(left: 115.0, right: 15),
                    child: Divider(
                      color: AppColor.white,
                    ),
                  ),
              ],
            );
          }
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
            ],
          );
        },
      );
    });
  }

  Widget itemBuilder(
      {@required Song song,
      @required int index,
      @required MusicProvider provider}) {
    return ListTile(
      leading: SizedBox(
          width: 95,
          height: 150,
          child: song?.image != null && song.image.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: song.image,
                  placeholder: (context, index) => Container(
                    child: Center(
                        child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator())),
                  ),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                )
              : null),
      title: GestureDetector(
        onTap: () async {
          _musicProvider.songs = _musicProvider.allSongs;
          _musicProvider.setCurrentIndex(index);
          int width = MediaQuery.of(context).size.width.floor();
          PageRouter.gotoWidget(SongViewScreen(song, width), context);
        },
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          title: TextViewWidget(
            text: song?.songName ?? 'Unknown',
            color: provider?.currentSong?.fileName == song?.fileName
                ? AppColor.bottomRed
                : AppColor.white,
            textSize: 15,
            fontFamily: 'Roboto-Regular',
          ),
          subtitle: TextViewWidget(
            text: song?.artistName ?? 'Unknown Artist',
            color: provider?.currentSong?.fileName == song?.fileName
                ? AppColor.bottomRed
                : AppColor.white,
            textSize: 13,
            fontFamily: 'Roboto-Regular',
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
    );
  }
}
