import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:mp3_music_converter/database/model/log.dart';
import 'package:mp3_music_converter/database/repository/log_repository.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/page_router/navigator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'display_downloaded_screen.dart';

const debug = true;
const String musicPath = '.music';

class MyHomePage extends StatefulWidget with WidgetsBindingObserver {
  final TargetPlatform platform;

  MyHomePage({Key key, this.title, this.platform}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading;
  bool _permissionReady;
  static String _localPath;
  ReceivePort _port = ReceivePort();
  String _fileName;

  @override
  void initState() {
    super.initState();

    _bindBackgroundIsolate(); //

    FlutterDownloader.registerCallback(
        downloadCallback); // register our callbacks

    _isLoading = true;
    _permissionReady = false;

    _prepare();
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

// handles the background process's so it communicates effectively with the main
// thread
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
      }
      String id = data[0];
      DownloadTaskStatus status = data[1];

      int progress = data[2];
      if (status == DownloadTaskStatus.complete)
        LogRepository.addLogs(Log(fileName: _fileName, filePath: _localPath));

      /// navigates user when download completes
      PageRouter.gotoWidget(DownloadedScreen(), context);
    });
  }

// removes our backgroung communications with the main
// process's
  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  /// Our static callbacks
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) async {
    if (debug) {
      print(
          'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    }
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    //  since this a static functions which runs in isolates
    // sends and updates the main isolates of the background isolates
    send.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget?.title ?? 'App Bar'),
      ),
      body: Builder(
          builder: (context) => _isLoading
              ? new Center(
                  child: new CircularProgressIndicator(),
                )
              : _permissionReady
                  ? Center(
                      child: RaisedButton(
                        onPressed: () {
                          _requestDownload(
                              link:
                                  'https://tooxclusive.com/enoheva-the-blood/'); // todo: replace with ur actuall link to download
                        },
                        child: Text('Download'),
                      ),
                    )
                  : _buildNoPermissionWarning()),
    );
  }

// displays this widget when there is no permission granted to our application
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
              FlatButton(
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

//* requests for downloads to begin
  void _requestDownload({@required String link}) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      _fileName = getStringPathName(link);
      setState(() {});
      await FlutterDownloader.enqueue(
          url: link,
          headers: {"auth": "test_for_sql_encoding"},
          savedDir: _localPath,
          fileName: _fileName,
          showNotification: true,
          openFileFromNotification: false);
    }
  }

//* checks for users permission
//* and returns true if the permission is granted and false if no permission is granted to our application
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
        musicPath; // gets users

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
}
