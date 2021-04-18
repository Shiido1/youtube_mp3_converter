import 'dart:io';

import 'package:mp3_music_converter/playlist/create_playlist_screen.dart';
import 'package:mp3_music_converter/playlist/select_playlist_screen.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/widgets/progress_indicator.dart';
import 'package:mp3_music_converter/utils/utilFold/splitAssistant.dart';
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
import 'dart:isolate';
import 'dart:ui';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import '../utils/color_assets/color.dart';
import '../utils/page_router/navigator.dart';

const String splitMusicPath = '.split';
bool debug = true;

class AppDrawer extends StatefulWidget with WidgetsBindingObserver {
  final TargetPlatform platform;
  AppDrawer({Key key, this.platform}) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  List<String> splitedFileList = [];
  List<Song> splittedSongList = [];
  MusicProvider _musicProvider;
  bool loading = false;
  int _progress = 0;
  bool downloaded;
  int id;
  var val;
  bool _isLoading;
  bool _permissionReady;
  static String _localPath;
  ReceivePort _port = ReceivePort();
  String _fileName;

  CustomProgressIndicator _progressIndicator;

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
    return Consumer<MusicProvider>(builder: (_, _provider, __) {
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
                        _musicProvider?.drawerItem?.fileName?.isNotEmpty ??
                                false
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
                      InkWell(
                        onTap: () => _musicProvider.updateSong(
                            _musicProvider.drawerItem
                              ..favorite = _musicProvider.drawerItem.favorite
                                  ? false
                                  : true),
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              AppAssets.favorite,
                              height: 20.8,
                              color: _musicProvider.drawerItem.favorite
                                  ? AppColor.red
                                  : AppColor.white,
                            ),
                            TextViewWidget(
                              text: 'Favorite',
                              color: AppColor.white,
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _musicProvider.shuffle();
                          PageRouter.goBack(context);
                        },
                        child: Column(
                          children: [
                            SvgPicture.asset(AppAssets.shuffle),
                            TextViewWidget(
                                text: 'Shuffle', color: AppColor.white)
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _musicProvider.repeat(_musicProvider.drawerItem);
                          PageRouter.goBack(context);
                        },
                        child: Column(
                          children: [
                            SvgPicture.asset(AppAssets.repeat),
                            TextViewWidget(
                                text: 'Repeat', color: AppColor.white)
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          Share.shareFiles([
                            File('${_musicProvider.drawerItem.filePath}/${_musicProvider.drawerItem.fileName}')
                                .path
                          ]);
                          PageRouter.goBack(context);
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
                  if (_musicProvider?.drawerItem?.playList ?? false)
                    Wrap(
                      children: [
                        ListTile(
                          onTap: () {
                            _musicProvider.updateSong(
                                _musicProvider.drawerItem..playList = false);
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
                      ],
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
                    if(!(_musicProvider?.drawerItem?.playList ?? false))
                      Expanded(
                        child: Wrap(
                        children: [
                          Divider(
                            color: AppColor.white,
                          ),
                          ListTile(
                            onTap: () {
                              _musicProvider.updateSong(_musicProvider.drawerItem..playList = true);
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
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
