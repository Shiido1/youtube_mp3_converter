import 'package:cached_network_image/cached_network_image.dart';
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
              Expanded(
                child: CachedNetworkImage(
                  imageUrl: _provider?.currentSong?.image ?? '',
                  imageBuilder: (context, imageProvider) => Container(
                    width: 280.0,
                    height: 320.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: TextViewWidget(
                  text: _provider?.currentSong?.songName ?? 'Unknown',
                  color: AppColor.white,
                  textSize: 15,
                  fontFamily: 'Roboto-Regular',
                ),
                subtitle: TextViewWidget(
                  text: _provider?.currentSong?.artistName ?? 'Unknown Artist',
                  color: AppColor.white,
                  textSize: 13,
                  fontFamily: 'Roboto-Regular',
                ),
              ),
              SizedBox(
                height: 40,
              ),
              SliderClass3(),
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
