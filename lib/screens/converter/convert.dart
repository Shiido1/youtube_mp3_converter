import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/screens/converter/provider/converter_provider.dart';
import 'package:mp3_music_converter/screens/dashboard/main_dashboard.dart';
import 'package:mp3_music_converter/screens/downloads/downloads.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/screens/converter/show_download_dialog.dart';
import 'package:mp3_music_converter/utils/helper/constant.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/widgets/bottom_playlist_indicator.dart';
import 'package:mp3_music_converter/widgets/red_background_backend/red_background.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:mp3_music_converter/screens/song/provider/music_provider.dart';
import 'package:http/http.dart' as http;

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
  int id;
  var val;
  bool _isLoading;
  bool _permissionReady;
  static String _localPath;
  MusicProvider musicProvider;
  String artist = '';
  String song = '';
  String token;
  int libid;
  String musicId;

  init() async {
    token = await preferencesHelper.getStringValues(key: 'token');
  }

  @override
  void initState() {
    _converterProvider = Provider.of<ConverterProvider>(context, listen: false);
    _converterProvider.init(context);
    musicProvider = Provider.of<MusicProvider>(context, listen: false);
    init();
    _isLoading = true;
    _permissionReady = false;

    _prepare();
    _setControllerText();

    if (widget.sharedLinkText != null && widget.sharedLinkText.isNotEmpty) {
      artist = '';
      song = '';
      _download('${widget.sharedLinkText.trim()}');
    }

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _setControllerText() {
    setState(() {
      controller.text = widget.sharedLinkText ?? null;
    });
  }

  void _download(String text) {
    if (controller.text.isEmpty) {
      showToast(context, message: "Please input Url");
    } else {
      _converterProvider.convert(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ConverterProvider>(builder: (_, model, __) {
        print(model.youtubeModel.id);
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
                          onPressed: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => MainDashBoard())),
                        ),
                        text: 'Converter',
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 6, bottom: 6, left: 30),
                        child: TextViewWidget(
                            color: AppColor.white,
                            text: 'Enter Url',
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
                                labelText: widget.sharedLinkText ?? 'Enter Url',
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
                                    artist = '';
                                    song = '';
                                    _download('${controller.text.trim()}');
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
                                                        onPressed: () async {
                                                          saveAndDownloadSong(
                                                              model);
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
                                                        onPressed: () async {
                                                          saveAndDownloadSong(
                                                              model);
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

  saveAndDownloadSong(ConverterProvider model) async {
    final result =
        await showDownloadDialog(context: context, song: song, artist: artist);
    if (result != null) {
      song = result.split('+')[0];
      artist = result.split('+')[1];
      String url = base_url + _converterProvider?.youtubeModel?.url;
      try {
        final response = await http.post('http://67.205.165.56/api/saveconvert',
            body: jsonEncode(
                {'token': token, 'id': model?.youtubeModel?.id.toString()}),
            headers: {'Content-Type': 'application/json'});

        Map responseData = jsonDecode(response.body);
        print(responseData['message']);
        if (responseData['message'].toString().toLowerCase().trim() ==
            'you cant add this song twice!!') {
          try {
            final data = await http.post('http://67.205.165.56/api/mylib',
                body: jsonEncode({'token': token}),
                headers: {'Content-Type': 'application/json'});
            if (data.statusCode == 200) {
              Map decodedData = jsonDecode(data.body);
              Map song;
              for (Map songData in decodedData['mainlib']) {
                if (songData['title'] == model.youtubeModel.title) {
                  song = songData;
                  break;
                }
              }
              libid = song['libid'];
              musicId = song['musicid'].toString();
            } else {
              libid = null;
              musicId = null;
            }
          } catch (e) {
            libid = null;
            musicId = null;
          }
        } else if (responseData['message'].toString().toLowerCase().trim() ==
            'music saved to library') {
          libid = responseData['libid'];
          musicId = model?.youtubeModel?.id.toString();
        } else {
          libid = null;
          musicId = null;
        }
      } catch (e) {
        libid = null;
        musicId = null;
      }

      if (libid != null && musicId != null)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Downloads(
              localPath: _localPath,
              convert: {
                'url': url,
                'artist': artist,
                'libid': libid,
                'musicId': musicId,
                'song': song,
                'image': _converterProvider?.youtubeModel?.image ?? ''
              },
            ),
          ),
        );
      else {
        showToast(context,
            message: 'Failed to process song details. Try again later');
        _download(controller.text);
      }
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

  // void _requestDownload(
  //     {@required String link, bool saveToDownload = false}) async {
  //   final status = await Permission.storage.request();

  //   if (status.isGranted) {
  //     if (saveToDownload = true) {
  //       var downloadPath = await DownloadsPathProvider.downloadsDirectory;
  //       _localPath = downloadPath.path;
  //     }

  //     _fileName = getStringPathName(link);
  //     await FlutterDownloader.enqueue(
  //         url: link,
  //         headers: {"auth": "test_for_sql_encoding"},
  //         savedDir: _localPath,
  //         fileName: _fileName,
  //         showNotification: true,
  //         openFileFromNotification: false);
  //   }
  // }

  // Widget downloadProgress() {
  //   return downloaded == true
  //       ? Text(
  //           'Downloading ' + _progress.toString() + '%',
  //           style: TextStyle(
  //               fontSize: 15,
  //               fontWeight: FontWeight.bold,
  //               color: AppColor.white),
  //         )
  //       : Text(
  //           'Saving to Library... ' + _progress.toString() + '%',
  //           style: TextStyle(
  //               fontSize: 15,
  //               fontWeight: FontWeight.bold,
  //               color: AppColor.white),
  //         );
  // }

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
