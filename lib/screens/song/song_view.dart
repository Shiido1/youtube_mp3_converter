import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  @override
  _SongViewCLassState createState() => _SongViewCLassState();
}

class _SongViewCLassState extends State<SongViewCLass> {
  MusicProvider _musicProvider;
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _musicProvider = Provider.of<MusicProvider>(context, listen: false);
    _musicProvider.getSongs();
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
        itemBuilder: (BuildContext context, int index) {
          Song _song = _provider.allSongs[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
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
                title: GestureDetector(
                  onTap: () async {
                    _musicProvider.songs = _musicProvider.allSongs;
                    _musicProvider.setCurrentIndex(index);
                    PageRouter.gotoWidget(SongViewScreen(_song), context);
                  },
                  child: TextViewWidget(
                    text: _song?.fileName ?? '',
                    color: AppColor.white,
                    textSize: 15,
                    fontFamily: 'Roboto-Regular',
                  ),
                ),
                trailing: InkWell(
                  onTap: () {
                    _musicProvider.updateDrawer(_song);
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
