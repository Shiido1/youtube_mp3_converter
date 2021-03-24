import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/screens/song/provider/music_provider.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/drawer.dart';
import 'package:mp3_music_converter/widgets/slider2_widget.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:provider/provider.dart';
import 'package:mp3_music_converter/widgets/icon_button.dart';

// ignore: must_be_immutable
class SongViewScreen extends StatefulWidget {
  String img, flname, mp3File;
  SongViewScreen(
    this.img,
    this.flname,
    this.mp3File, {
    Key key,
  }) : super(key: key);

  @override
  _SongViewScreenState createState() => _SongViewScreenState();
}

class _SongViewScreenState extends State<SongViewScreen> {
  String _fileName, _image, _mp3File;
  MusicProvider _musicProvider;
  String mp3 = '';

  @override
  void initState() {
    super.initState();
    _musicProvider = Provider.of<MusicProvider>(context, listen: false);
    prefMed();
    setState(() {
      _image = widget.img;
      _fileName = widget.flname;
      _mp3File = widget.mp3File;
    });
    _musicProvider.handlePlaying(_mp3File, state: AudioPlayerState.COMPLETED);
  }

  prefMed() {
    preferencesHelper.getStringValues(key: 'mp3').then((value) => setState(() {
          mp3 = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicProvider>(builder: (_, provider, __) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.grey,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_sharp,
              color: AppColor.white,
            ),
          ),
        ),
        endDrawer: Theme(
            data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
            child: AppDrawer()),
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
                    imageUrl: _image,
                    height: 400,
                    width: 280,
                    fit: BoxFit.contain,
                  ),
                ),
                Center(
                  child: TextViewWidget(
                    text: _fileName,
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
                      onPressed: () {},
                      iconSize: 56,
                      color: AppColor.white,
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
                      onPressed: () {},
                      iconSize: 56,
                      color: AppColor.white,
                    ),
                    SizedBox(
                      height: 65,
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
