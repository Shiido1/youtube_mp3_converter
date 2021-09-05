import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/database/repository/song_repository.dart';
import 'package:mp3_music_converter/screens/favorite/favorite_songs.dart';
import 'package:mp3_music_converter/screens/recorded/recorded.dart';
import 'package:mp3_music_converter/screens/song/provider/music_provider.dart';
import 'package:mp3_music_converter/screens/song/song_view.dart';
import 'package:mp3_music_converter/screens/split/split_songs.dart';
import 'package:mp3_music_converter/screens/world_radio/radio_class.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/bottom_playlist_indicator.dart';
import 'package:mp3_music_converter/widgets/red_background_backend/red_background2.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:provider/provider.dart';
import '../screens/song/song_view_screen.dart';
import '../utils/page_router/navigator.dart';
import 'package:mp3_music_converter/screens/split/sing_along.dart';
import 'package:mp3_music_converter/screens/downloads/downloads.dart';

class Library extends StatefulWidget {
  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
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
  initState() {
    super.initState();
  }

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
            RedBackground2(
              text: 'Library',
              openRadio: openRadio,
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 16, right: 16),
                child: ListView(children: [
                  ListTile(
                    onTap: () {
                      Provider.of<MusicProvider>(context, listen: false)
                          .updateCurrentIndex(1);
                    },
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
                    onTap: () {
                      int width = MediaQuery.of(context).size.width.floor();
                      PageRouter.gotoWidget(SongViewCLass(width), context);
                    },
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
                    onTap: () => PageRouter.gotoWidget(SingAlong(), context),
                    leading: SvgPicture.asset(
                      AppAssets.mpFile,
                      color: Colors.white,
                      height: 27,
                    ),
                    title: TextViewWidget(
                      text: 'Sing Along',
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
                        MaterialPageRoute(builder: (context) => SplitScreen()),
                      );
                    },
                    leading: SvgPicture.asset(AppAssets.split),
                    title: TextViewWidget(
                      text: 'Voiceover',
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
                    onTap: () => PageRouter.gotoWidget(Downloads(), context),
                    leading: Icon(
                      Icons.download_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                    title: TextViewWidget(
                      text: 'Downloads',
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
                                        onTap: () {
                                          int width = MediaQuery.of(context)
                                              .size
                                              .width
                                              .floor();
                                          PageRouter.gotoWidget(
                                              SongViewScreen(e, width),
                                              context);
                                        },
                                        child: CachedNetworkImage(
                                          imageUrl: e.image,
                                          errorWidget: (context, data, _) =>
                                              Container(
                                                  color: Colors.white54,
                                                  height: 30,
                                                  width: 150,
                                                  child: Icon(
                                                    Icons.error,
                                                    size: 35,
                                                  )),
                                        ),
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
