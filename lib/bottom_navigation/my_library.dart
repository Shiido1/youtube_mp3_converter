import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mp3_music_converter/bottom_navigation/playlist.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/database/repository/song_repository.dart';
import 'package:mp3_music_converter/screens/favorite/favorite_songs.dart';
import 'package:mp3_music_converter/screens/recorded/recorded.dart';
import 'package:mp3_music_converter/screens/song/song_view.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/bottom_playlist_indicator.dart';
import 'package:mp3_music_converter/widgets/red_background.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import '../screens/song/song_view_screen.dart';
import '../utils/page_router/navigator.dart';

class Library extends StatefulWidget {
  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: AppColor.background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RedBackground(
              text: 'Library',
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 16, right: 16),
                child: ListView(children: [
                  ListTile(
                    onTap: () => PageRouter.gotoWidget(PlayList(), context),
                    leading: SvgPicture.asset(AppAssets.library),
                    title: TextViewWidget(
                      text: 'Playlists',
                      color: AppColor.white,
                      textSize: 18,
                    ),
                  ),
                  Divider(
                    color: AppColor.white,
                  ),
                  ListTile(
                    onTap: () =>
                        PageRouter.gotoWidget(SongViewCLass(), context),
                    leading: SvgPicture.asset(AppAssets.music),
                    title: TextViewWidget(
                      text: 'Song',
                      color: AppColor.white,
                      textSize: 18,
                    ),
                  ),
                  Divider(
                    color: AppColor.white,
                  ),
                  ListTile(
                    onTap: () =>
                        PageRouter.gotoWidget(FavoriteSongs(), context),
                    leading: SvgPicture.asset(AppAssets.favorite),
                    title: TextViewWidget(
                      text: 'Favorite',
                      color: AppColor.white,
                      textSize: 18,
                    ),
                  ),
                  Divider(
                    color: AppColor.white,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Recorded()),
                      );
                    },
                    leading: SvgPicture.asset(AppAssets.record),
                    title: TextViewWidget(
                      text: 'Recorded',
                      color: AppColor.white,
                      textSize: 18,
                    ),
                  ),
                  Divider(
                    color: AppColor.white,
                  ),
                  ListTile(
                    onTap: () {},
                    leading: SvgPicture.asset(AppAssets.split),
                    title: TextViewWidget(
                      text: 'Splitted',
                      color: AppColor.white,
                      textSize: 18,
                    ),
                  ),
                  Divider(
                    color: AppColor.white,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextViewWidget(
                    text: 'Recently Added',
                    color: AppColor.white,
                    textSize: 20,
                    fontFamily: 'Montserrat',
                  ),
                  Container(
                    height: 100,
                    margin: EdgeInsets.only(top: 10),
                    child: StreamBuilder<List<Song>>(
                        stream: SongRepository.streamAllSongs(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          }
                          return ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapshot.data
                                .map((e) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () => PageRouter.gotoWidget(
                                            SongViewScreen(e), context),
                                        child: CachedNetworkImage(
                                            imageUrl: e.image),
                                      ),
                                    ))
                                .toList(),
                          );
                        }),
                  )
                ]),
              ),
            ),
            BottomPlayingIndicator(),
          ],
        ),
      ),
    );
  }
}
