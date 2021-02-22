import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mp3_music_converter/save_convert/provider/save_provider.dart';
import 'package:mp3_music_converter/screens/converter/provider/converter_provider.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/constant.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/page_router/navigator.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DownloadAndSaveScreen extends StatefulWidget {
  @override
  _DownloadAndSaveScreenState createState() => _DownloadAndSaveScreenState();
}

class _DownloadAndSaveScreenState extends State<DownloadAndSaveScreen> {
  bool loading = false;
  // String url;
  // String progress;
  String filePath;
  SharedPreferences loginPref;
  bool newUser;

  ConverterProvider _converterProvider;
  SaveConvertProvider _saveConvertProvider;
  TextEditingController controller = new TextEditingController();
  int _progress = 0;
  ReceivePort receivePort = ReceivePort();

  static downloadingCallback(id, status, progress) {
    SendPort sendPort = IsolateNameServer.lookupPortByName('downloading');
    sendPort.send([id, status, progress]);
  }

  Future<void> _showDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 170, 20, 250),
            child: AlertDialog(
                backgroundColor: AppColor.white.withOpacity(0.5),
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
                        SvgPicture.asset(AppAssets.attention),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          'You have to login first',
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

    loginPref = await SharedPreferences.getInstance();
    if (loginPref.getBool('login') ?? false) {
      if (status.isGranted) {
        final externalDir = await getExternalStorageDirectory();

        final id = await FlutterDownloader.enqueue(
            url: base_url + _converterProvider?.youtubeModel?.url,
            savedDir: externalDir.path,
            fileName: _converterProvider?.youtubeModel?.title,
            showNotification: true,
            openFileFromNotification: true);
        setState(() {
          loading = true;
        });
      } else {
        print('Permission denied');
      }
    } else {
      _showDialog(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _converterProvider = Provider.of<ConverterProvider>(context, listen: false);
    // fileDownloaderProvider = Provider.of<FileDownloaderProvider>(context,listen: false);
    _converterProvider.init(context);
    IsolateNameServer.registerPortWithName(receivePort.sendPort, "downloading");
    receivePort.listen((message) {
      // setState(() {
      //   _progress = message[2];
      // });
      // print(_progress);
    });
    FlutterDownloader.registerCallback(downloadingCallback);
  }

  //

  //
  // Future<List<Directory>> _getExternal(){
  //   return p.getExternalStorageDirectories(type: p.StorageDirectory.documents);
  // }

  // Future _downloadFileToStorage(BuildContext context, String url, String filename) async {
  //   ProgressDialog pr;
  //   pr = new ProgressDialog(context,type: ProgressDialogType.Normal);
  //   pr.style(message: 'Downloading file ...');
  //  try{
  //    await pr.show();
  //    final dirList = await _getExternal();
  //    final path = dirList[0].path;
  //    final file = File('$path/$filename');
  //    await dio.download(url, file.path, onReceiveProgress: (rec, total){
  //      setState(() {
  //        _isLoading=true;
  //        progress = ((rec/total)*100).toStringAsFixed(0)+" %";
  //        print(progress);
  //        pr.update(message: 'Please wait : $progress');
  //      });
  //    });
  //    pr.hide();
  //    filePath = file.path;
  //  }catch(e){
  //    print(e);
  //  }
  //  setState(() {
  //    _isLoading = false;
  //  });
  // }

  // Widget downloadButton(FileDownloaderProvider downloaderProvider){
  //   return FlatButton(onPressed: (){
  //     fileDownloaderProvider.performFileDownloading("http://youtubeaudio.com/"+url, "My File.mp4").then((onValue){});
  //
  //   },
  //       color:AppColor.background,child: Text(
  //         'Download',
  //         style: TextStyle(color: Colors.white, fontSize: 20),
  //       ));
  // }

  Widget downloadProgress() {
    // var fileDownloaderProvider = Provider.of<FileDownloaderProvider>(context,listen: true);
    return Text(
      'Downloading...',
      style: TextStyle(
          fontSize: 15, fontWeight: FontWeight.bold, color: AppColor.white),
    );
  }
  //
  // downloadStatus(FileDownloaderProvider fileDownloaderProvider){
  //   var retStatus = '';
  //
  //   switch (fileDownloaderProvider.downloadStatus){
  //     case DownloadStatus.Downloading:
  //       {
  //         retStatus = "Download Progress: "+fileDownloaderProvider.downloadPercentage.toString()+"";
  //       }
  //       break;
  //     case DownloadStatus.Complete:
  //       {
  //         retStatus = "Download Completed: ";
  //       }
  //       break;
  //     case DownloadStatus.NotStarted:
  //       {
  //         retStatus = "Click Download Button";
  //       }
  //       break;
  //     case DownloadStatus.Started:
  //       {
  //         retStatus = "Download Started";
  //       }
  //       break;
  //   }
  //   return retStatus;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ConverterProvider>(
        builder: (_, converter, __) => SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: new BoxDecoration(
              color: Color(0xff000000),
              image: new DecorationImage(
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.5), BlendMode.dstATop),
                image: new AssetImage(
                  AppAssets.bgImage1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 200),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'Enter YouTube Url',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),
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
                SizedBox(height: 10),
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
                                          converter?.youtubeModel?.image ?? '',
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
                                                  converter?.youtubeModel
                                                          ?.title ??
                                                      '',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                  )),
                                              SizedBox(height: 10),
                                              Text(
                                                  'File Size: ${converter?.youtubeModel?.filesize ?? '0'}',
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
                                    onPressed: () {},
                                    child: Text(
                                      'Save to lib',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ))
                              ],
                            ),
                            SizedBox(height: 40),
                            loading == false
                                ? Container()
                                : Center(child: downloadProgress()),
                          ],
                        ),
                      )
                    : Container(),
                SizedBox(height: 50),
                // Center(
                //   child: FlatButton(
                //       color: Colors.grey,
                //       onPressed: () {
                //         downloadNow();
                //         // _downloadFileToStorage(context, url, "mp3 File.mp3");
                //       },
                //       child: Text(
                //         'Download',
                //         style: TextStyle(color: AppColor.white),
                //       )),
                // ),
                // SizedBox(height: 10),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     // Expanded(
                //     //   child: Column(
                //     //     children: [
                //     //       downloadButton(fileDownloaderProvider),
                //     //       downloadProgress()
                //     //     ],
                //     //   ),
                //     // ),
                //     FlatButton(
                //         onPressed: () {
                //           _download();
                //           // setState(() {
                //           //   url = controller.text;
                //           // });
                //         },
                //         color: Colors.green,
                //         child: Text(
                //           'Download',
                //           style: TextStyle(color: Colors.white, fontSize: 20),
                //         )),
                //     SizedBox(width: 20),
                //     FlatButton(
                //         color: Colors.red,
                //         onPressed: () {},
                //         child: Text(
                //           'Save to lib',
                //           style: TextStyle(
                //             color: Colors.white,
                //             fontSize: 20,
                //           ),
                //         ))
                //   ],
                // ),
                // SizedBox(height: 40),
                // loading == false
                //     ? Container()
                //     : Center(child: downloadProgress()),
                // SizedBox(height: 40),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () =>
                            PageRouter.gotoNamed(Routes.SIGNUP, context),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                      SizedBox(width: 20),
                      InkWell(
                        onTap: () =>
                            PageRouter.gotoNamed(Routes.LOGIN, context),
                        child: Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.w800),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _download() {
    if (controller.text.isEmpty) {
      showToast(context, message: "Please input Url");
    } else {
      _converterProvider.convert(
          '${controller.text}', _converterProvider?.youtubeModel?.id ?? '');
    }
  }
}
