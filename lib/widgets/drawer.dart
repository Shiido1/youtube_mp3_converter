import 'dart:io';

import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/database/repository/song_repository.dart';
import 'package:mp3_music_converter/playlist/create_playlist_screen.dart';
import 'package:mp3_music_converter/playlist/select_playlist_screen.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/utilFold/splitAssistant.dart';
import 'package:mp3_music_converter/widgets/progress_indicator.dart';
import 'package:path_provider/path_provider.dart';
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

const String splitMusicPath = 'split';
bool debug = true;

class AppDrawer extends StatefulWidget with WidgetsBindingObserver {
  final TargetPlatform platform;
  AppDrawer({Key key, this.platform}) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  List<String> _apiSplittedList = [];
  List<String> splittedSongIDList = [];
  List<dynamic> dataList = [];
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
  bool shuffle;
  bool repeat;

  CustomProgressIndicator _progressIndicator;

  Future<List<String>> pickFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    return result == null ? <String>[] : result.paths;
  }

  @override
  void initState() {
    _musicProvider = Provider.of<MusicProvider>(context, listen: false);
    this._progressIndicator = CustomProgressIndicator(this.context);

    _bindBackgroundIsolate(); //
    FlutterDownloader.registerCallback(
        downloadCallback); // register our callbacks
    _isLoading = true;
    _permissionReady = false;
    _prepare();
    shuffle = _musicProvider.shuffleSong;
    repeat = _musicProvider.repeatSong;

    super.initState();
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) async {
      if (debug) {
        print('UI Isolate Callback: $data');
        dataList.add(data);
      }

      // ignore: unused_local_variable
      String id = data[0];
      DownloadTaskStatus status = data[1];

      int progress = data[2];
      setState(() {
        _progress = progress;
        loading = true;
      });
      if (_progress == 100) {
        // _showDialog(context);
        setState(() {
          loading = false;
        });
      }
      if (status == DownloadTaskStatus.complete) {
        if (data[0].toString() == splittedSongIDList.first.toString()) {
          print('Data at index 0 is ${data[0].toString()}');
          print(
              'SplittedSongIDList at index 0 is ${splittedSongIDList.first.toString()}');
          SplittedSongRepository.addSong(Song(
            fileName: _fileName,
            filePath: _localPath,
            image: _musicProvider?.drawerItem?.image ?? '',
            splittedFileName: _musicProvider?.drawerItem?.fileName ?? '',
          ));

          //Todo: delay a bit and then show a dialog or navigate to the
        }
      }
    });

  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) async {
    if (debug) {
      print(
          'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    }

    final SendPort send =
    IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  Future<void> _requestDownload(
      {@required String link, bool saveToDownload = false}) async {
    final status = await Permission.storage.request();

    if (status.isGranted) {
      if (saveToDownload) {
        var downloadPath = await DownloadsPathProvider.downloadsDirectory;
        _localPath = downloadPath.path;
      }

      _fileName = getStringPathName(link);
      // setState(() {
      //   downloaded = false;
      // });
      await FlutterDownloader.enqueue(
              url: link,
              headers: {"auth": "test_for_sql_encoding"},
              savedDir: _localPath,
              fileName: _fileName,
              showNotification: true,
              openFileFromNotification: true)
          .then((value) => splittedSongIDList.add(value));
    }
  }

  Future<bool> _checkPermission() async {
    if (widget.platform == TargetPlatform.android) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

//* prepares the items we wish to download
  Future<Null> _prepare() async {
    _permissionReady = await _checkPermission(); // checks for users permission

    _localPath = (await _findLocalPath()) +
        Platform.pathSeparator +
        splitMusicPath; // gets users

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }

    setState(() {
      _isLoading = false;
    });
  }

//* finds available space for storage on users device
  Future<String> _findLocalPath() async {
    final directory = widget.platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicProvider>(builder: (_, _provider, __) {
      return Padding(
        padding: const EdgeInsets.only(top: 120, bottom: 90),
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
                          _provider?.drawerItem?.image?.isNotEmpty ?? false
                              ? Expanded(
                                  child: Container(
                                      height: 60,
                                      width: 50,
                                      child: CachedNetworkImage(
                                          imageUrl:
                                              _provider?.drawerItem?.image)))
                              : Container(),
                          _provider?.drawerItem?.fileName?.isNotEmpty ??
                                  false
                              ? Expanded(
                                  child: TextViewWidget(
                                  text: _provider?.drawerItem?.fileName,
                                  color: AppColor.white,
                                  textSize: 16.5,
                                  fontWeight: FontWeight.w500,
                                ))
                              : Container()
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () => _provider.updateSong(_provider.drawerItem
                          ..favorite =
                              _provider.drawerItem.favorite ? false : true),
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              AppAssets.favorite,
                              height: 20.8,
                              color: _provider.drawerItem.favorite
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
                          shuffle
                              ? _musicProvider.stopShuffle()
                              : _musicProvider.shuffle(false);
                          PageRouter.goBack(context);
                        },
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              AppAssets.shuffle,
                              color:
                                  shuffle ? AppColor.bottomRed : AppColor.white,
                            ),
                            TextViewWidget(
                                text: 'Shuffle', color: AppColor.white)
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          repeat
                              ? _provider.undoRepeat()
                              : _provider.repeat(_provider.drawerItem);
                          PageRouter.goBack(context);
                        },
                        child: Column(
                          children: [
                            SvgPicture.asset(AppAssets.repeat,
                                color: repeat
                                    ? AppColor.bottomRed
                                    : AppColor.white),
                            TextViewWidget(
                                text: 'Repeat', color: AppColor.white)
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          Share.shareFiles([
                            File('${_provider.drawerItem.filePath}/${_provider.drawerItem.fileName}')
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
                  ListTile(
                    onTap: () async {
                      _progressIndicator.show();
                      // FilePickerResult result = await FilePicker.platform
                      //     .pickFiles(type: FileType.audio);
                      String result = '${_provider.drawerItem.filePath}/'
                          '${_provider.drawerItem.fileName}';
                      var splittedFiles =
                          await SplitAssistant.splitFile(result, context);
                      if (splittedFiles != "Failed") {
                        bool isSaved = await SplitAssistant.saveSplitFiles(
                            splittedFiles, context);
                        if (isSaved && _permissionReady) {
                          String drumsUrl = splittedFiles["files"]["drums"];
                          String voiceUrl = splittedFiles["files"]["voice"];
                          String bassUrl = splittedFiles["files"]["bass"];
                          String otherUrl = splittedFiles["files"]["other"];

                              _apiSplittedList.clear();
                              splittedSongIDList.clear();
                              _apiSplittedList.add(otherUrl);
                              _apiSplittedList.add(drumsUrl);
                              _apiSplittedList.add(voiceUrl);
                              _apiSplittedList.add(bassUrl);

                              print('splitedFileList.length is ${_apiSplittedList.length}');

                               for (int i = 0; i < _apiSplittedList.length; i++) {
                                print('i is ****************** $i');
                                await _requestDownload(
                                    link: _apiSplittedList[i],
                                    saveToDownload: true);
                               }
                          }

                            else if(!_permissionReady){
                              _buildNoPermissionWarning();
                            }
                            else {
                                _progressIndicator.dismiss();
                              showToast(context,
                                  message: "error occurred, please try again");
                            }
                              _progressIndicator.dismiss();

                          }
                        },
                        leading: SvgPicture.asset(AppAssets.split),
                        title: TextViewWidget(
                          text: 'Split Song',
                          color: AppColor.white,
                          textSize: 18,
                        ),
                      ),
                    ),
                    Divider(
                      color: AppColor.white,
                    ),
                    Expanded(child:ListTile(
                      onTap: () {},
                      leading: SvgPicture.asset(AppAssets.record),
                      title: TextViewWidget(
                        text: 'Record',
                        color: AppColor.white,
                        textSize: 18,
                      ),
                    )),
                    Divider(
                      color: AppColor.white,
                    ),
                    ListTile(
                      onTap: () async {
                        await _musicProvider.getPlayListNames();
                        PageRouter.goBack(context);
                        _musicProvider.playLists.isEmpty
                            ? createPlayListScreen(
                                context: context,
                                songName:
                                    _musicProvider.drawerItem.fileName,
                                showToastMessage: true)
                            : selectPlayListScreen(
                                context: context,
                                songName:
                                    _musicProvider.drawerItem.fileName);
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
            ),
          ),
      );
    });
  }
  Widget _buildNoPermissionWarning() => Container(
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Please grant accessing storage permission to continue -_-',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blueGrey, fontSize: 18.0),
            ),
          ),
          SizedBox(
            height: 32.0,
          ),
          TextButton(
              onPressed: () {
                _checkPermission().then((hasGranted) {
                  setState(() {
                    _permissionReady = hasGranted;
                  });
                });
              },
              child: Text(
                'Retry',
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ))
        ],
      ),
    ),
  );

}
