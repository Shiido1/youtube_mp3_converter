import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/database/repository/song_repository.dart';
import 'package:mp3_music_converter/screens/converter/provider/converter_provider.dart';
import 'package:mp3_music_converter/screens/song/song_view.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/constant.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/bottom_playlist_indicator.dart';
import 'file:///C:/Users/u/AndroidStudioProjects/mp3_music_converter/lib/widgets/red_background_backend/red_background.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:mp3_music_converter/screens/song/provider/music_provider.dart';

const String musicPath = '.music';
bool debug = true;

class Convert extends StatefulWidget with WidgetsBindingObserver {
  final TargetPlatform platform;
  final String sharedLinkText;

  Convert({
    Key key,
    this.platform,
    this.sharedLinkText,
  }) : super(key: key);
  @override
  _ConvertState createState() => _ConvertState();
}

class _ConvertState extends State<Convert> {
  ConverterProvider _converterProvider;
  bool convertResult = false;
  TextEditingController controller = new TextEditingController();
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
  MusicProvider musicProvider;

  @override
  void initState() {
    _converterProvider = Provider.of<ConverterProvider>(context, listen: false);
    _converterProvider.init(context);
    musicProvider = Provider.of<MusicProvider>(context, listen: false);

    _bindBackgroundIsolate(); //
    FlutterDownloader.registerCallback(
        downloadCallback); // register our callbacks
    _isLoading = true;
    _permissionReady = false;
    _prepare();
    _setControllerText();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    _unbindBackgroundIsolate();
    super.dispose();
  }

  void _setControllerText() {
    setState(() {
      controller.text = widget.sharedLinkText ?? null;
    });
  }

  void _download(String text){
    if (controller.text.isEmpty) {
      showToast(context, message: "Please input Url");
    } else {_converterProvider.convert(text);
    }
  }

  Future<void> _showDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 170, 20, 250),
            child: AlertDialog(
                backgroundColor: AppColor.white.withOpacity(0.6),
                content: Container(
                  decoration: new BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(32.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 50),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(AppAssets.check),
                          SizedBox(
                            height: 11.5,
                          ),
                          Center(
                            child: TextViewWidget(
                              color: AppColor.black,
                              fontWeight: FontWeight.w500,
                              textSize: 21,
                              text: downloaded == true
                                  ? 'Successfully Downloaded'
                                  : 'Successfully Saved to Library',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          // Text(
                          //   'Successfully Downloaded',
                          //   textAlign: TextAlign.center,
                          //   style: TextStyle(
                          //       fontSize: 23,
                          //       fontWeight: FontWeight.w600,
                          //       color: AppColor.black),
                          // ),
                        ],
                      ),
                    ),
                  ),
                )),
          );
        });
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
        await _showDialog(context);
        setState(() {
          loading = false;
        });
      }
      if (status == DownloadTaskStatus.complete) {
        await SongRepository.addSong(Song(
          fileName: _fileName,
          filePath: _localPath,
          image: _converterProvider?.youtubeModel?.image ?? '',
          playList: false,
          favorite: false,
          lastPlayDate: DateTime.now(),
        ));
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => SongViewCLass()));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ConverterProvider>(builder: (_, model, __) {
        return Container(
          color: AppColor.background,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RedBackground(
                        iconButton: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios_outlined,
                            color: AppColor.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        text: 'Converter',
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 6, bottom: 6, left: 30),
                        child: TextViewWidget(
                            color: AppColor.white,
                            text: 'Enter Youtube Url',
                            textSize: 23,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Montserrat'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Stack(children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 58.0),
                            child: TextFormField(
                              style: TextStyle(color: AppColor.white),
                              decoration: new InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                border: new OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                labelText: widget.sharedLinkText ??
                                    'Enter Youtube Url',
                                labelStyle: TextStyle(color: Colors.white),
                              ),
                              cursorColor: AppColor.white,
                              controller: controller,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(23.0),
                                border: Border.all(color: AppColor.white),
                              ),
                              child: ClipOval(
                                child: InkWell(
                                  splashColor: Colors.white, // inkwell color
                                  child: Container(
                                      height: 55,
                                      width: 54,
                                      child: Icon(
                                        Icons.check,
                                        color: AppColor.white,
                                        size: 35,
                                      )),
                                  onTap: () {
                                    _download('${controller.text}');
                                  },
                                ),
                              ),
                            ),
                          )
                        ]),
                      ),
                      model.problem == true
                          ? Container(
                              child: Column(
                                children: [
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.4),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(2),
                                              child: Image.network(
                                                model?.youtubeModel?.image ??
                                                    '',
                                                width: 115,
                                                height: 120,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        model?.youtubeModel
                                                                ?.title ??
                                                            '',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                        )),
                                                    SizedBox(height: 10),
                                                    Text(
                                                        'File Size: ${model?.youtubeModel?.filesize ?? '0'}',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                        )),
                                                    SizedBox(height: 30),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 50),
                                  Builder(
                                      builder: (context) => _isLoading
                                          ? new Center(
                                              child:
                                                  new CircularProgressIndicator(),
                                            )
                                          : _permissionReady
                                              ? Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          _requestDownload(
                                                              link: base_url +
                                                                  _converterProvider
                                                                      ?.youtubeModel
                                                                      ?.url,
                                                              saveToDownload:
                                                                  true);
                                                          setState(() {
                                                            downloaded = true;
                                                          });
                                                        },
                                                        style: TextButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              AppColor.green,
                                                        ),
                                                        child: TextViewWidget(
                                                          text: 'Download',
                                                          color: AppColor.white,
                                                          textSize: 20,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 16,
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          _requestDownload(
                                                              link: base_url +
                                                                  _converterProvider
                                                                      ?.youtubeModel
                                                                      ?.url);
                                                          setState(() {
                                                            downloaded = false;
                                                          });
                                                          // todo: replace with ur actuall link to download
                                                        },
                                                        style: TextButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              AppColor.green,
                                                        ),
                                                        child: TextViewWidget(
                                                          text: 'Save to Lib',
                                                          color: AppColor.white,
                                                          textSize: 20,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : _buildNoPermissionWarning()),
                                ],
                              ),
                            )
                          : Container(),
                      SizedBox(height: 60),
                      loading == false
                          ? Container()
                          : Center(child: downloadProgress()),
                      SizedBox(height: 60)
                    ],
                  ),
                ),
              ),
              BottomPlayingIndicator(),
            ],
          ),
        );
      }),
    );
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

  void _requestDownload(
      {@required String link, bool saveToDownload = false}) async {
    final status = await Permission.storage.request();

    if (status.isGranted) {
      if (saveToDownload) {
        var downloadPath = await DownloadsPathProvider.downloadsDirectory;
        _localPath = downloadPath.path;
      }

      _fileName = getStringPathName(link);
      await FlutterDownloader.enqueue(
          url: link,
          headers: {"auth": "test_for_sql_encoding"},
          savedDir: _localPath,
          fileName: _fileName,
          showNotification: true,
          openFileFromNotification: false);
    }
  }

  Widget downloadProgress() {
    return downloaded == true
        ? Text(
            'Downloading ' + _progress.toString() + '%',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColor.white),
          )
        : Text(
            'Saving to Library... ' + _progress.toString() + '%',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColor.white),
          );
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
        musicPath; // gets users

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
    print('path is: $_localPath');

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
