import 'dart:isolate';
import 'dart:io';
import 'dart:ui';

import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/database/repository/song_repository.dart';
import 'package:mp3_music_converter/screens/converter/convert.dart';
import 'package:mp3_music_converter/screens/payment/payment_screen.dart';
import 'package:mp3_music_converter/screens/song/provider/music_provider.dart';
import 'package:mp3_music_converter/screens/splitted/split_songs.dart';
import 'package:mp3_music_converter/screens/world_radio/radio_class.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/utils/utilFold/splitAssistant.dart';
import 'package:mp3_music_converter/widgets/bottom_playlist_indicator.dart';
import 'package:mp3_music_converter/widgets/progress_indicator.dart';
import 'package:mp3_music_converter/widgets/red_background.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:mp3_music_converter/utils/utilFold/linkShareAssistant.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

const String splitMusicPath = 'split';
bool debug = true;

// ignore: must_be_immutable
class DashBoard extends StatefulWidget with WidgetsBindingObserver {
  int index;
  final TargetPlatform platform;

  DashBoard({Key key, this.platform}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  HomeButtonItem _homeButtonItem = HomeButtonItem.NON;
  List<String> _apiSplittedList = ['', ''];
  String _sharedText = "";
  List<String> splittedFileList = [];
  List<Song> splittedSongList = [];
  List<String> splittedSongIDList = ['', ''];
  List<dynamic> dataList = [];
  bool _isLoading;
  bool _permissionReady;
  static String _localPath;
  ReceivePort _port = ReceivePort();
  List<String> _fileName = ['', ''];
  int _progress = 0;
  bool loading = false;

  MusicProvider _musicProvider;
  CustomProgressIndicator _progressIndicator;

  @override
  void initState() {
    _musicProvider = Provider.of<MusicProvider>(context, listen: false);
    _progressIndicator = CustomProgressIndicator(this.context);

    LinkShareAssistant()
      ..onDataReceived = _handleSharedData
      ..getSharedData().then(_handleSharedData);

    _bindBackgroundIsolate(); //
    FlutterDownloader.registerCallback(
        downloadCallback); // register our callbacks
    _isLoading = true;
    _permissionReady = false;
    _prepare();
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
      if (status == DownloadTaskStatus.complete) {
        if (data[0].toString() == splittedSongIDList[0].toString()) {
          SplittedSongRepository.addSong(Song(
            fileName: _fileName[0],
            filePath: _localPath,
            image: '',
            splittedFileName: splitFileNameHere(_fileName[0]),
          ));
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => SplittedScreen()));
        }
        if (data[0].toString() == splittedSongIDList[1].toString()) {
          SplittedSongRepository.addSong(Song(
              filePath: _localPath,
              image: '',
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

    // setState(() {
    //   _isLoading = false;
    // });
  }

//* finds available space for storage on users device
  Future<String> _findLocalPath() async {
    final directory = widget.platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// Handles any shared data we may receive.
  void _handleSharedData(String sharedData) {
    setState(() {
      _sharedText = sharedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_sharedText.length > 1)
      return Convert(sharedLinkText: _sharedText);
    else
      return Scaffold(
        backgroundColor: AppColor.background,
        body: Column(
          children: [
            RedBackground(),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 16, right: 90),
                child: ListView(
                  children: [
                    _buttonItem(
                      title: "Converter",
                      item: HomeButtonItem.CONVERTER,
                      screen: Convert(),
                      assets: AppAssets.mpFile,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _buttonItem(
                      title: "Split your Music",
                      item: HomeButtonItem.CREATE_MUSIC,
                      assets: AppAssets.radioWave,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _buttonItem(
                      title: "Radio World Wide",
                      item: HomeButtonItem.RADIO,
                      screen: RadioClass(),
                      assets: AppAssets.radio,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _buttonItem(
                      title: "Disk Jockey",
                      item: HomeButtonItem.DJ,
                      screen: Scaffold(
                        backgroundColor: AppColor.background,
                        appBar: AppBar(
                          backgroundColor: AppColor.bottomRed,
                          leading: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(
                              Icons.arrow_back_ios_sharp,
                              color: AppColor.white,
                            ),
                          ),
                        ),
                        body: Center(
                            child: TextViewWidget(
                          text: 'Coming Soon...!',
                          color: AppColor.white,
                          textSize: 18,
                        )),
                      ),
                      assets: AppAssets.djMixer,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _buttonItem(
                        title: "Plan",
                        item: HomeButtonItem.PLAN,
                        screen: PaymentScreen(),
                        assets: AppAssets.plan),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),
            BottomPlayingIndicator()
          ],
        ),
      );
  }

  Widget _buttonItem({
    String title,
    String assets,
    Widget screen,
    HomeButtonItem item,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          _homeButtonItem = item;
        });
        screen == null
            ? splitMethod()
            : Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => screen),
              );
      },
      child: Container(
          decoration: BoxDecoration(
              color: _homeButtonItem != item
                  ? AppColor.transparent
                  : Colors.redAccent[100].withOpacity(0.8),
              border: Border.all(
                color: _homeButtonItem != item
                    ? AppColor.white
                    : Colors.redAccent[100].withOpacity(0.8),
              ),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.all(13.0),
            child: Row(
              children: [
                SvgPicture.asset(
                  assets,
                  color:
                      _homeButtonItem != item ? AppColor.white : AppColor.black,
                  height: 24,
                  width: 25,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextViewWidget(
                    color: _homeButtonItem != item
                        ? AppColor.white
                        : AppColor.black,
                    text: '$title',
                    textSize: 18,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Future splitMethod() async {
    FilePickerResult result =
        await FilePicker.platform.pickFiles(type: FileType.audio);

    if (result != null && result.files.isNotEmpty) {
      _progressIndicator.show();

      String nameOfFile = result.files.single.name;

      var splittedFiles =
          await SplitAssistant.splitFile(result.files.single.path, context);
      print('This is the splitted file: $splittedFiles');
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
              fileName: nameOfFile);
          await _requestDownload(
              link: _apiSplittedList[1],
              saveToDownload: true,
              fileName: nameOfFile);
        } else if (!_permissionReady) {
          _buildNoPermissionWarning();
        } else {
          await _progressIndicator.dismiss();
          showToast(context, message: "error occurred, please try again");
        }
      }
      await _progressIndicator.dismiss();
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

enum HomeButtonItem { NON, CONVERTER, CREATE_MUSIC, RADIO, DJ, PLAN }
