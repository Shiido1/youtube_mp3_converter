import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/drawer.dart';
import 'package:mp3_music_converter/widgets/slider_widget.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';

class SongViewScreen extends StatefulWidget {
  String img, flname;
  SongViewScreen(
    this.img,
    this.flname, {
    Key key,
  }) : super(key: key);

  @override
  _SongViewScreenState createState() => _SongViewScreenState();
}

class _SongViewScreenState extends State<SongViewScreen> {
  String _fileName, _image;
  IconData _iconData = Icons.play_circle_outline;

  AudioPlayer _player;
  AudioCache cache;
  String mp3 = '';
  bool playing;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _player = AudioPlayer();
    cache = AudioCache(fixedPlayer: _player);
    init();
    setState(() {
      _image = widget.img;
      _fileName = widget.flname;
    });
  }

  init() {
    if (prefMed() == true) {
      prefMed();
      setState(() {
        // ignore: unnecessary_statements
        prefMed() == false;
        preferencesHelper
            .getBoolValues(key: 'prefMed')
            .then((value) => setState(() {}));
      });
    } else {
      return null;
    }
  }

  bool prefMed() {
    preferencesHelper.getStringValues(key: 'mp3').then((value) => setState(() {
          mp3 = value;
        }));
    if (mp3.isNotEmpty && mp3 != null && !playing) {
      preferencesHelper.getBoolValues(key: 'true').then((value) => setState(() {
            _iconData = Icons.pause_circle_outline;
            // playing = true;
          }));
    } else {
      setState(() {
        _iconData = Icons.play_circle_outline;
        // playing = false;
      });
    }
    preferencesHelper.saveValue(key: 'prefMed', value: true);
    return false;
  }

  playMeds() async {
    // _player.play(mp3);
    // if (mp3.isEmpty && mp3 == null) {
    //   setState(() {
    //     _iconData = Icons.play_circle_outline;
    //   });
    // preferencesHelper
    //     .getStringValues(key: 'mp3')
    //     .then((value) => setState(() {
    //           mp3 = value;
    //         }));
    // return null;
    // }
    if (mp3.isNotEmpty && mp3 != null) {
      await _player.play(mp3);

      preferencesHelper.getBoolValues(key: 'true').then((value) => setState(() {
            _iconData = Icons.pause_circle_outline;
            playing = true;
          }));
    } else {
      setState(() {
        _iconData = Icons.play_circle_outline;
        playing = false;
      });

      await _player.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(35.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18.0),
                  child: CachedNetworkImage(
                    imageUrl: _image,
                    height: 350,
                    width: 250,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextViewWidget(
                  text: _fileName,
                  color: AppColor.white,
                  textSize: 18,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(
                  height: 10,
                ),
                SliderClass(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.skip_previous_outlined),
                      onPressed: () {},
                      iconSize: 60,
                      color: AppColor.white,
                    ),
                    IconButton(
                      icon: Icon(_iconData),
                      onPressed: () {
                        playMeds();
                      },
                      iconSize: 60,
                      color: AppColor.white,
                    ),
                    IconButton(
                      icon: Icon(Icons.skip_next_outlined),
                      onPressed: () {},
                      iconSize: 60,
                      color: AppColor.white,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
