import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _image = widget.img;
      _fileName = widget.flname;
    });
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
                      icon: Icon(Icons.play_circle_outline),
                      onPressed: () {},
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
