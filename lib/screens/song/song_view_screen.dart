import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/screens/song/provider/music_provider.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/drawer.dart';
import 'package:mp3_music_converter/widgets/slider2_widget.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:provider/provider.dart';
import 'package:mp3_music_converter/widgets/icon_button.dart';

import '../../utils/color_assets/color.dart';
import 'provider/music_provider.dart';

// ignore: must_be_immutable
class SongViewScreen extends StatefulWidget {
  Song song;
  SongViewScreen(
    this.song, {
    Key key,
  }) : super(key: key);

  @override
  _SongViewScreenState createState() => _SongViewScreenState();
}

class _SongViewScreenState extends State<SongViewScreen> {
  MusicProvider _musicProvider;

  @override
  void initState() {
    _musicProvider = Provider.of<MusicProvider>(context, listen: false);
    _musicProvider.playerType = PlayerType.ALL;
    _musicProvider.playAudio(widget.song);
    _musicProvider.updateDrawer(widget.song);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicProvider>(builder: (_, _provider, __) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.grey,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_sharp,
              color: AppColor.white,
            ),
          ),
        ),
        endDrawer: Theme(
            data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
            child: AppDrawer()
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: new BoxDecoration(
            color: AppColor.grey,
            image: new DecorationImage(
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(
                  AppColor.black.withOpacity(0.5), BlendMode.dstATop),
              image: new AssetImage(
                AppAssets.bgImage2,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(35.0),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18.0),
                  child: CachedNetworkImage(
                    imageUrl: _provider.currentSong.image,
                    height: 400,
                    width: 280,
                    fit: BoxFit.contain,
                  ),
                ),
                Center(
                  child: TextViewWidget(
                    text: _provider.currentSong.fileName,
                    color: AppColor.white,
                    textSize: 18,
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                SliderClass2(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                      IconButton(
                        icon: Icon(Icons.skip_previous_outlined),
                        onPressed: () => !_provider.canPrevSong ?  _musicProvider.prev() : null,
                        iconSize: 56,
                        color: !_provider.canPrevSong ? AppColor.white : AppColor.grey,
                      ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: IconButt(),
                    ),
                    SizedBox(
                      width: 23,
                    ),
                    IconButton(
                    icon: Icon(Icons.skip_next_outlined),
                    onPressed: () => !_provider.canNextSong ? _musicProvider.next() : null,
                    iconSize: 56,
                    color: !_provider.canNextSong ? AppColor.white : AppColor.grey,
                  ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
