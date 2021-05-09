import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/database/repository/song_repository.dart';
import 'package:mp3_music_converter/screens/splitted/split_songs.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/utilFold/splitAssistant.dart';
import 'dart:isolate';

import 'package:mp3_music_converter/widgets/progress_indicator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

bool debug = true;
bool _permissionReady = false;

class Downloader {
  BuildContext context;
  TargetPlatform platform;

  Downloader({@required context, @required platform});

  static const String splitMusicPath = 'split';

  ReceivePort _port = ReceivePort();

  static String _localPath;
  List<String> _fileName = ['', ''];
  List<String> _apiSplittedList = ['', ''];
  List<String> splittedSongIDList = ['', ''];
  List<dynamic> dataList = [];
  int _progress = 0;

  init(String image) async {
    _bindBackgroundIsolate(image);
    FlutterDownloader.registerCallback(downloadCallback);
    await _prepare();
  }

  Future splitSongMethod(
      {@required String path,
      @required String fileName,
      @required CustomProgressIndicator progressIndicator}) async {
    CustomProgressIndicator(context).show();
    // '${_musicProvider.drawerItem.filePath}/'
    //     '${_musicProvider.drawerItem.fileName}';

    var splittedFiles = await SplitAssistant.splitFile(path, context);
    if (splittedFiles != "Failed") {
      progressIndicator.dismiss();
      bool isSaved =
          await SplitAssistant.saveSplitFiles(splittedFiles, context);

      if (isSaved && _permissionReady) {
        // String drumsUrl = splittedFiles["files"]["drums"];
        String voiceUrl = splittedFiles["files"]["voice"];
        // String bassUrl = splittedFiles["files"]["bass"];
        String otherUrl = splittedFiles["files"]["other"];

        _apiSplittedList = ['', ''];
        splittedSongIDList = ['', ''];
        _fileName = ['', ''];
        // _apiSplittedList.insert(0, 'name');
        // _apiSplittedList.insert(1, 'Niza');

        // _apiSplittedList.insert(0, otherUrl);
        _apiSplittedList.insert(0, otherUrl);
        // // _apiSplittedList.add(drumsUrl);
        // _apiSplittedList.insert(1, voiceUrl);
        _apiSplittedList.insert(1, voiceUrl);
        // _apiSplittedList.add(bassUrl);
//  _musicProvider.drawerItem.fileName
        // await _requestDownload(
        //     link: _apiSplittedList[0],
        //     saveToDownload: true,
        //     fileName: fileName);

        // await _requestDownload(
        //     link: _apiSplittedList[1],
        //     saveToDownload: true,
        //     fileName: fileName);
        // for (int i = 0; i < _apiSplittedList.length; i++) {
        //  print('i is ****************** $i');
        //  await _requestDownload(
        //      link: _apiSplittedList[i],
        //      saveToDownload: true);
        // }
      } else if (!_permissionReady) {
        _buildNoPermissionWarning();
      } else {
        await progressIndicator.dismiss();
        showToast(context, message: "error occurred, please try again");
      }
      await progressIndicator.dismiss();
    } else {
      progressIndicator.dismiss();
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
                      _permissionReady = hasGranted;
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

  String splitFileNameHere(String fileName) {
    List name = fileName.split('-');
    name.removeLast();
    return name.join('-');
  }

  void _bindBackgroundIsolate(String image) {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      unbindBackgroundIsolate();
      _bindBackgroundIsolate(image);
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
      _progress = progress;
      // setState(() {

      //   loading = true;
      // });
      showToast(context,
          message: 'Downloading Splitted files ' + _progress.toString() + '%');
      if (_progress == 100) {
        showToast(context, message: 'Downloaded Splitted file');
        // setState(() {
        //   loading = false;
        // });
      }
      if (status == DownloadTaskStatus.complete) {
        if (data[0].toString() == splittedSongIDList[0].toString()) {
          SplittedSongRepository.addSong(Song(
            fileName: _fileName[0],
            filePath: _localPath,
            image: image ?? '',
            splittedFileName: splitFileNameHere(_fileName[0]),
          ));
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => SplittedScreen()));
        }
        if (data[0].toString() == splittedSongIDList[1].toString()) {
          SplittedSongRepository.addSong(Song(
              filePath: _localPath,
              image: image ?? '',
              splittedFileName: splitFileNameHere(_fileName[1]),
              vocalName: _fileName[1]));
          print('downlaoded vocals');
        }
      }
    });
  }

  void unbindBackgroundIsolate() {
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
      @required String fileName}) async {
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
    if (platform == TargetPlatform.android) {
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
    final directory = platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
