import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mp3_music_converter/screens/song/provider/music_provider.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/slider2_widget.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:provider/provider.dart';

class SplitSongScreen extends StatefulWidget {
  @override
  _SplitSongScreenState createState() => _SplitSongScreenState();
}

class _SplitSongScreenState extends State<SplitSongScreen> {
  MusicProvider _musicProvider;

  @override
  void initState() {
    _musicProvider = Provider.of<MusicProvider>(context, listen: false);
    _musicProvider.playerType = PlayerType.ALL;
    // _musicProvider.playAudio(widget.song);
    // _musicProvider.updateDrawer(widget.song);
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
        body: Container(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  height: 250,
                  width: 250,
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      image: new DecorationImage(
                        image: new AssetImage(AppAssets.image1),
                        fit: BoxFit.contain,
                      ))),
              SizedBox(
                height: 20,
              ),
              Center(
                child: TextViewWidget(
                  text: _provider?.currentSong?.fileName ?? 'Something Fishy',
                  color: AppColor.white,
                  textSize: 18,
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              SliderClass2(),
              SizedBox(
                height: 40,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        icon: Icon(Icons.play_circle_outline_rounded,
                            size: 65, color: AppColor.white),
                        onPressed: () {}),
                    IconButton(
                        icon: Icon(
                          Icons.mic,
                          size: 65,
                          color: AppColor.white,
                        ),
                        onPressed: () {}),
                  ],
                ),
              ),
              SizedBox(
                height: 100,
              ),
              Container(
                height: 90,
                color: AppColor.black,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          SvgPicture.asset(
                            AppAssets.vocal,
                            color: AppColor.white,
                          ),
                          TextViewWidget(text: 'Vocals', color: AppColor.white)
                        ],
                      ),
                      Column(
                        children: [
                          SvgPicture.asset(
                            AppAssets.instrumental,
                            color: AppColor.white,
                          ),
                          TextViewWidget(
                              text: 'Instrumental', color: AppColor.white)
                        ],
                      ),
                      Column(
                        children: [
                          Icon(
                            Icons.share,
                            size: 30,
                            color: AppColor.white,
                          ),
                          TextViewWidget(text: 'Save', color: AppColor.white)
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
