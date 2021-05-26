import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/screens/dashboard/main_dashboard.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/widgets/bottom_playlist_indicator.dart';
import 'package:mp3_music_converter/widgets/red_background_backend/red_background.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:provider/provider.dart';

import '../../utils/page_router/navigator.dart';
import '../song/provider/music_provider.dart';
import '../song/song_view_screen.dart';

class FavoriteSongs extends StatefulWidget {
  @override
  _FavoriteSongsState createState() => _FavoriteSongsState();
}

class _FavoriteSongsState extends State<FavoriteSongs> {
  MusicProvider _musicProvider;
  @override
  void initState() {
    _musicProvider = Provider.of<MusicProvider>(context, listen: false);
    _musicProvider.getFavoriteSongs();
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
            text: 'Favorites',
          ),
          Expanded(child: Consumer<MusicProvider>(
            builder: (_, _provider, __) {
              if (_provider.favoriteSongs.length == 0) {
                return Center(
                    child:
                        TextViewWidget(text: 'No Song', color: AppColor.white));
              }
              return ListView.builder(
                itemCount: _provider.favoriteSongs.length,
                itemBuilder: (BuildContext context, int index) {
                  Song _song = _provider.favoriteSongs[index];
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
                            _musicProvider.songs = _musicProvider.favoriteSongs;
                            PageRouter.gotoWidget(
                                SongViewScreen(_song), context);
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
                              text: _song?.artistName ?? 'Unknown Artist',
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
                      if (_provider.favoriteSongs.length - 1 != index)
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
