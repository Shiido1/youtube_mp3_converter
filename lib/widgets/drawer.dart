import 'dart:io';

import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/database/repository/song_repository.dart';
import 'package:mp3_music_converter/playlist/create_playlist_screen.dart';
import 'package:mp3_music_converter/playlist/select_playlist_screen.dart';
import 'package:mp3_music_converter/screens/splitted/database/split_services.dart';
import 'package:mp3_music_converter/screens/splitted/split_songs.dart';
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
import 'package:mp3_music_converter/screens/splitted/delete_song.dart';
import 'package:mp3_music_converter/screens/recorded/recorder_services.dart';

const String splitMusicPath = 'split';
bool debug = true;

class AppDrawer extends StatefulWidget with WidgetsBindingObserver {
  final TargetPlatform platform;
  AppDrawer({Key key, this.platform}) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  List<String> _apiSplittedList = ['', ''];
  List<String> splittedSongIDList = ['', ''];
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
  List<String> _fileName = ['', ''];
  bool shuffle;
  bool repeat;

  CustomProgressIndicator _progressIndicator;

  // Future<List<String>> pickFile() async {
  //   final result = await FilePicker.platform.pickFiles(allowMultiple: true);
  //   return result == null ? <String>[] : result.paths;
  // }

  @override
  void initState() {
    _musicProvider = Provider.of<MusicProvider>(context, listen: false);
    this._progressIndicator = CustomProgressIndicator(this.context);
    _bindBackgroundIsolate();
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

  String splitFileNameHere(String fileName) {
    List name = fileName.split('-');
    name.removeLast();
    return name.join('-');
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
      showToast(context,
          message: 'Downloading Splitted files ' + _progress.toString() + '%');
      if (_progress == 100) {
        showToast(context, message: 'Downloaded Splitted file');
        setState(() {
          loading = false;
        });
      }
      // if (status == DownloadTaskStatus.failed) {
      //   String newId = await FlutterDownloader.retry(taskId: data[0]);
      //   if (data[0].toString() == splittedSongIDList[0].toString())
      //     splittedSongIDList[0] = newId;
      //   if (data[0].toString() == splittedSongIDList[1].toString())
      //     splittedSongIDList[1] = newId;
      // }
      if (status == DownloadTaskStatus.complete ||
          (status.toString() == "DownloadTaskStatus(3)" && progress == 100)) {
        if (data[0].toString() == splittedSongIDList[0].toString()) {
          SplittedSongRepository.addSong(Song(
            fileName: _fileName[0],
            filePath: _localPath,
            image: _musicProvider?.drawerItem?.image ?? '',
            splittedFileName: splitFileNameHere(_fileName[0]),
          ));
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => SplittedScreen()));
        }
        if (data[0].toString() == splittedSongIDList[1].toString()) {
          SplittedSongRepository.addSong(Song(
              filePath: _localPath,
              image: _musicProvider?.drawerItem?.image ?? '',
              splittedFileName: splitFileNameHere(_fileName[1]),
              vocalName: _fileName[1]));
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
      {@required String link,
      bool saveToDownload = false,
      String fileName}) async {
    final status = await Permission.storage.request();

    if (status.isGranted) {
      if (saveToDownload) {
        var downloadPath = await DownloadsPathProvider.downloadsDirectory;
        _localPath = downloadPath.path;
      }

      if (getStringPathName(link) == 'vocals.wav')
        _fileName[1] = fileName + "-" + getStringPathName(link);
      else
        _fileName[0] = fileName + "-" + getStringPathName(link);

      bool splitVoc =
          await File(_localPath + Platform.pathSeparator + _fileName[1])
              .exists();
      bool splitAcm =
          await File(_localPath + Platform.pathSeparator + _fileName[0])
              .exists();

      if (!splitVoc && !splitAcm) {
        await FlutterDownloader.registerCallback(downloadCallback);
        await FlutterDownloader.enqueue(
                url: link,
                headers: {"auth": "test_for_sql_encoding"},
                savedDir: _localPath,
                fileName: getStringPathName(link) == 'vocals.wav'
                    ? _fileName[1]
                    : _fileName[0],
                showNotification: true,
                openFileFromNotification: true)
            .then((value) => splittedSongIDList.insert(
                getStringPathName(link) == 'vocals.wav' ? 1 : 0, value));
      } else if (splitVoc && !splitAcm) {
        await FlutterDownloader.registerCallback(downloadCallback);
        await FlutterDownloader.enqueue(
                url: link,
                headers: {"auth": "test_for_sql_encoding"},
                savedDir: _localPath,
                fileName: _fileName[0],
                showNotification: true,
                openFileFromNotification: true)
            .then((value) => splittedSongIDList.insert(0, value));
      } else if (!splitVoc && splitAcm) {
        await FlutterDownloader.registerCallback(downloadCallback);
        await FlutterDownloader.enqueue(
                url: link,
                headers: {"auth": "test_for_sql_encoding"},
                savedDir: _localPath,
                fileName: _fileName[1],
                showNotification: true,
                openFileFromNotification: true)
            .then((value) => splittedSongIDList.insert(1, value));
      } else
        showToast(context, message: 'File already exists');
      //   if (!(await File(_localPath + Platform.pathSeparator + _fileName[0])
      //     .exists()))

      // if (!(await File(_localPath + Platform.pathSeparator + _fileName[1])
      //     .exists()))

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

  printThis() async {
    List songss = await SplittedSongServices().getKeys();

    print(songss);

    List<Song> songer = await SplittedSongServices().getSongs();
    for (Song song in songer) print(song.file);
  }

  @override
  Widget build(BuildContext context) {
    // SplittedSongServices().deleteSong('him');
    // printThis();
    // SplittedSongServices()
    //     .addSong(Song(splittedFileName: 'him', vocalName: 'this.vocal.wav'));
    // RecorderServices().clear();
    // SplittedSongServices().deleteSong('');
    // SongRepository
    // SplittedSongServices()
    // .addSong(Song(
    //     fileName: 'Nizatreasure.wav',
    //     filePath: 'storage/emulated/0/Download',
    //     image: 'http://img.youtube.com/vi/sQR2-Q-k_9Y/mqdefault.jpg',
    //     splittedFileName: 'Nizatreasure.mp3',
    //     vocalName: 'Nizatreasure.mp3-vocals.wav'));

    // print(_musicProvider.drawerItem.file);
    // FlutterDownloader.cancelAll();
    return Consumer<MusicProvider>(builder: (_, _provider, __) {
      // print(_provider?.drawerItem?.file);
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
                        _provider?.drawerItem?.image?.isNotEmpty ?? false
                            ? Expanded(
                                child: Container(
                                    height: 60,
                                    width: 50,
                                    child: CachedNetworkImage(
                                        imageUrl:
                                            _provider?.drawerItem?.image)))
                            : Container(),
                        _provider?.drawerItem?.fileName?.isNotEmpty ?? false
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
                  SizedBox(
                    height: 40,
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
                    onTap: () => splitSongMethod(),
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
                  Wrap(
                    children: [
                      ListTile(
                        onTap: () async {
                          await _musicProvider.getPlayListNames();
                          PageRouter.goBack(context);
                          _musicProvider.playLists.isEmpty
                              ? createPlayListScreen(
                                  context: context,
                                  songName: _musicProvider.drawerItem.fileName,
                                  showToastMessage: true)
                              : selectPlayListScreen(
                                  context: context,
                                  songName: _musicProvider.drawerItem.fileName);
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
                  Expanded(
                    child: Wrap(
                      children: [
                        Divider(
                          color: AppColor.white,
                        ),
                        ListTile(
                          onTap: () async {
                            Navigator.pop(context);
                            DeleteSongs(context).showConfirmDeleteDialog(
                                song: _provider?.drawerItem);
                          },
                          leading: SvgPicture.asset(AppAssets.rubbish),
                          title: TextViewWidget(
                            text: 'Delete Song',
                            color: AppColor.white,
                            textSize: 18,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Future splitSongMethod() async {
    _progressIndicator.show();
    String result = '${_musicProvider.drawerItem.filePath}/'
        '${_musicProvider.drawerItem.fileName}';
    var splittedFiles = await SplitAssistant.splitFile(result, context);
    if (splittedFiles != "Failed") {
      _progressIndicator.dismiss();
      bool isSaved =
          await SplitAssistant.saveSplitFiles(splittedFiles, context);
      if (isSaved && _permissionReady) {
        String voiceUrl = splittedFiles["files"]["voice"];
        String otherUrl = splittedFiles["files"]["other"];
        _apiSplittedList = ['', ''];
        splittedSongIDList = ['', ''];
        _fileName = ['', ''];
        _apiSplittedList.insert(0, otherUrl);
        _apiSplittedList.insert(1, voiceUrl);

        await _requestDownload(
            link: _apiSplittedList[0],
            saveToDownload: true,
            fileName: _musicProvider.drawerItem.fileName);
        await _requestDownload(
            link: _apiSplittedList[1],
            saveToDownload: true,
            fileName: _musicProvider.drawerItem.fileName);
      } else if (!_permissionReady) {
        _buildNoPermissionWarning();
      } else {
        await _progressIndicator.dismiss();
        showToast(context, message: "error occurred, please try again");
      }
      await _progressIndicator.dismiss();
    } else {
      _progressIndicator.dismiss();
      showToast(context, message: 'Please try again later');
    }
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
