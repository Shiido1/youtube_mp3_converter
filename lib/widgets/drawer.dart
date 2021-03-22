import 'package:mp3_music_converter/screens/playlist/database/model/playlist_log.dart';
import 'package:mp3_music_converter/screens/playlist/database/repo/playlist_log_repo.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:share/share.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mp3_music_converter/screens/song/provider/music_provider.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/page_router/navigator.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatefulWidget {
  AppDrawer({Key key}) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  MusicProvider _musicProvider;

  Future<List<String>> pickFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    return result == null ? <String>[] : result.paths;
  }

  @override
  void initState() {
    super.initState();
    _musicProvider = Provider.of<MusicProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 150, bottom: 120),
      child: Drawer(
        child: Container(
          decoration: BoxDecoration(color: AppColor.black.withOpacity(0.5)),
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _musicProvider?.drawerItem?.image?.isNotEmpty ?? false
                          ? Expanded(
                              child: Container(
                                  height: 60,
                                  width: 50,
                                  child: CachedNetworkImage(
                                      imageUrl:
                                          _musicProvider?.drawerItem?.image)))
                          : Container(),
                      _musicProvider?.drawerItem?.fileName?.isNotEmpty ?? false
                          ? Expanded(
                              child: TextViewWidget(
                              text: _musicProvider?.drawerItem?.fileName,
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
                        final filePath = await pickFile();
                        if (filePath.isEmpty) {
                          showToast(context, message: "Select file to share");
                        } else {
                          Share.shareFiles(filePath);
                        }
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
                  onTap: () {
                    PlayListLogRepository.deleteLog(
                        _musicProvider?.drawerItem?.fileName);
                    PageRouter.gotoNamed(Routes.PLAYLIST, context);
                  },
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
                      PlayListLogRepository.addLogs((PlayListLog(
                          fileName: _musicProvider?.drawerItem?.fileName,
                          image: _musicProvider?.drawerItem?.image,
                          file: _musicProvider?.drawerItem?.fileName)));
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
