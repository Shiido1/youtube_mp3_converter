import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:mp3_music_converter/save_convert/model/save_convert_model.dart';
import 'package:mp3_music_converter/save_convert/provider/save_provider.dart';
import 'package:mp3_music_converter/screens/converter/model/youtube_model.dart';
import 'package:mp3_music_converter/screens/converter/provider/converter_provider.dart';
import 'package:mp3_music_converter/screens/dashboard/sample_dashboard.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/constant.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/bottom_playlist_indicator.dart';
import 'package:mp3_music_converter/widgets/red_background.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'model/downloaded_file_model.dart';

class Convert extends StatefulWidget {
  @override
  _ConvertState createState() => _ConvertState();
}

class _ConvertState extends State<Convert> {
  ConverterProvider _converterProvider;
  bool convertResult = false;
  TextEditingController controller = new TextEditingController();
  bool loading = false;
  int _progress = 0;
  static int _progresss = 0;
  bool downloaded = false;
  int id;
  var val;
  var storagePath;

  ReceivePort receivePort = ReceivePort();

  static downloadingCallback(id, status, progress) {
    SendPort sendPort = IsolateNameServer.lookupPortByName('downloading');
    sendPort.send([id, status, progress]);
    _progresss = progress;
  }

  void _download() {
    if (controller.text.isEmpty) {
      showToast(context, message: "Please input Url");
    } else {
      _converterProvider.convert('${controller.text}');
    }
  }

  _saveLib() async {
    // if (downloaded == true) {
    //   setState(() async {
    //     id = await _saveConvertProvider.saveConvert(_id);
    //   });
    // }
    DownloadedFile file = DownloadedFile(
        read(base_url + _converterProvider?.youtubeModel?.url),
        path: storagePath,
        image: _converterProvider?.youtubeModel?.image,
        title: _converterProvider?.youtubeModel?.title);
    // Hive
    //   ..init(storagePath)
    //   ..registerAdapter(DownloadedFileAdapter());
    // var save = await Hive.openBox('music_db');
    // save.put('key', file);
    // save.get('key');
    final downBox = Hive.box('music_db');
    await  downBox.add(file);
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
                    padding: const EdgeInsets.only(top: 50, bottom: 70),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(AppAssets.check),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          'Successfully Downloaded',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: AppColor.black),
                        ),
                      ],
                    ),
                  ),
                )),
          );
        });
  }

  Future downloadNow() async {
    final status = await Permission.storage.request();

    if (status.isGranted) {
      final externalDir = await getExternalStorageDirectory();
      setState(() {
        storagePath = externalDir.path;
      });
      final idDownloadPath = await FlutterDownloader.enqueue(
          url: base_url + _converterProvider?.youtubeModel?.url,
          savedDir: storagePath,
          fileName: _converterProvider?.youtubeModel?.title,
          showNotification: true,
          openFileFromNotification: true);
      print('path location' + externalDir.path);

      IsolateNameServer.registerPortWithName(
          receivePort.sendPort, "downloading");
      setState(() {
        _progress = _progresss;
        downloaded = true;
        loading = true;
      });
      print(_progress);
      FlutterDownloader.registerCallback(downloadingCallback);
      if (_progress == 100) {
        _showDialog(context);
        setState(() {
          loading = false;
          _progress = 0;
        });
      }
    } else {
      showToast(context, message: 'problem connecting to network');
      setState(() {
        loading = false;
      });
    }
  }

  // void _playSound() {
  //   AudioPlayer player = AudioPlayer();
  //   player.play(mp3);
  // }
  //
  // Future<void> _loadSong() async {
  //   final ByteData data = await rootBundle.load(v);
  //   File tempFile = File('$w');
  //   await tempFile.writeAsBytes(data.buffer.asUint8List(), flush: true);
  //   mp3 = tempFile.uri.toString();
  // }

  Widget downloadProgress() {
    return Text(
      'Downloading $_progress%',
      style: TextStyle(
          fontSize: 15, fontWeight: FontWeight.bold, color: AppColor.white),
    );
  }

  @override
  void initState() {
    _converterProvider = Provider.of<ConverterProvider>(context, listen: false);
    _converterProvider.init(context);
    IsolateNameServer.registerPortWithName(receivePort.sendPort, "downloading");
    receivePort.listen((message) {
      setState(() {
        _progress = message[2];
        downloaded = true;
        loading = true;
      });
      if (_progress == 100) {
        _showDialog(context);
        setState(() {
          loading = false;
          _progress = 0;
        });
      }
      print(_progress);
    });
    FlutterDownloader.registerCallback(downloadingCallback);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    receivePort.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ConverterProvider>(builder: (_, model, __) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: AppColor.background,
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
                      MaterialPageRoute(builder: (context) => Sample()),
                    ),
                  ),
                  text: 'Converter',
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 6, left: 30),
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
                          labelText: 'Enter Youtube Url',
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
                              _download();
                            },
                          ),
                        ),
                      ),
                    )
                  ]),
                ),
                _converterProvider.problem == true
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Image.network(
                                    model?.youtubeModel?.image ?? '',
                                    width: 115,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            model?.youtubeModel?.title ??
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FlatButton(
                              onPressed: () {
                                downloadNow();
                              },
                              color: Colors.green,
                              child: Text(
                                'Download',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              )),
                          SizedBox(width: 20),
                          FlatButton(
                              color: Colors.red,
                              onPressed: () {
                                _saveLib();
                              },
                              child: Text(
                                'Save to lib',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ))
                        ],
                      ),
                    ],
                  ),
                )
                    : Container(),
                SizedBox(height: 60),
                loading == false
                    ? Container()
                    : Center(child: downloadProgress()),
                SizedBox(
                  height: 307,
                ),
                BottomPlayingIndicator(),
              ],
            ),
          ),
        );
      }),
    );
  }
}