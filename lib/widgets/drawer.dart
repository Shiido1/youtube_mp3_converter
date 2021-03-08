import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/utils/page_router/navigator.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:share/share.dart';

class AppDrawer extends StatefulWidget {
  String filename, image;

  AppDrawer({Key key, this.filename, this.image}) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String _filename, _image;

  // _AppDrawerState({@required this.filename, @required this.image});
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  init() {
    setState(() {
      _filename = widget.filename;
      _image = widget.image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 150, bottom: 120),
      child: Drawer(
        child: Container(
          decoration: BoxDecoration(color: AppColor.black.withOpacity(0.5)),
          // color: AppColor.black.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _image != null && _image.isNotEmpty
                          ? Expanded(
                              child: Container(
                                  height: 60,
                                  width: 50,
                                  child: CachedNetworkImage(imageUrl: _image)))
                          : Container(),
                      _filename != null && _filename.isNotEmpty
                          ? Expanded(
                              child: TextViewWidget(
                              text: _filename,
                              color: AppColor.white,
                              textSize: 16.5,
                              fontWeight: FontWeight.w500,
                            ))
                          : Container()
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        SvgPicture.asset(
                          AppAssets.favorite,
                          height: 20.8,
                        ),
                        TextViewWidget(
                          text: 'Favorite',
                          color: AppColor.white,
                        )
                      ],
                    ),
                    Column(
                      children: [
                        SvgPicture.asset(AppAssets.shuffle),
                        TextViewWidget(text: 'Shuffle', color: AppColor.white)
                      ],
                    ),
                    Column(
                      children: [
                        SvgPicture.asset(AppAssets.repeat),
                        TextViewWidget(text: 'Repeat', color: AppColor.white)
                      ],
                    ),
                    InkWell(
                      onTap: () async {
                        // final filePath = await pickFile();
                        // if (filePath.isEmpty){
                        //   showToast(context, message: "Select file to share");
                        // }else {
                        //   Share.shareFiles(filePath);
                        // }
                      },
                      child: Column(
                        children: [
                          SvgPicture.asset(AppAssets.share),
                          TextViewWidget(text: 'Share', color: AppColor.white)
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: AppColor.white,
                ),
                ListTile(
                  onTap: () {},
                  leading: SvgPicture.asset(AppAssets.rubbish),
                  title: TextViewWidget(
                    text: 'Remove from Playlist',
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
                    text: 'Split Song',
                    color: AppColor.white,
                    textSize: 18,
                  ),
                ),
                Divider(
                  color: AppColor.white,
                ),
                ListTile(
                  onTap: () {},
                  leading: SvgPicture.asset(AppAssets.record),
                  title: TextViewWidget(
                    text: 'Record',
                    color: AppColor.white,
                    textSize: 18,
                  ),
                ),
                Divider(
                  color: AppColor.white,
                ),
                Expanded(
                  child: ListTile(
                    onTap: () {
                      PageRouter.gotoNamed(Routes.PLAYLIST, context);
                    },
                    leading: Icon(
                      Icons.add_box_outlined,
                      color: AppColor.white,
                    ),
                    title: TextViewWidget(
                      text: 'Add to Playlist',
                      color: AppColor.white,
                      textSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
