import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:mp3_music_converter/download/download_provider.dart';
import 'package:mp3_music_converter/screens/converter/provider/converter_provider.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart' as p;

class DownloadAndSaveScreen extends StatefulWidget {

  @override
  _DownloadAndSaveScreenState createState() => _DownloadAndSaveScreenState();
}

class _DownloadAndSaveScreenState extends State<DownloadAndSaveScreen> {

  bool _isLoading = false;
  // String url;
  String progress;
  String filePath;
  // Dio dio;

  ConverterProvider _converterProvider;
  // FileDownloaderProvider fileDownloaderProvider;
  TextEditingController controller = new TextEditingController();
  static downloadingCallback(id, status,progress){

  }

    @override
  void initState() {
    super.initState();
    _converterProvider = Provider.of<ConverterProvider>(context, listen: false);
    // fileDownloaderProvider = Provider.of<FileDownloaderProvider>(context,listen: false);
    _converterProvider.init(context);
    // FlutterDownloader.registerCallback(downloadingCallback);

    // dio = Dio();
  }


  Future downloadNow() async{
    final taskId = await FlutterDownloader.enqueue(
      url: "https://youtubeaudio.com/"+_converterProvider.youtubeModel.url,
      savedDir: 'the path of directory where you want to save downloaded files',
      showNotification: true, // show download progress in status bar (for Android)
      openFileFromNotification: true, // click on notification to open downloaded file (for Android)
    );
  }

  Future<List<Directory>> _getExternal(){
    return p.getExternalStorageDirectories(type: p.StorageDirectory.documents);
  }

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

  // Widget downloadProgress(){
  //   var fileDownloaderProvider = Provider.of<FileDownloaderProvider>(context,listen: true);
  //   return Text(downloadStatus(fileDownloaderProvider),
  //   style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold,color: AppColor.white),);
  // }
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
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 220),
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
                    padding: const EdgeInsets.only(right: 20.0, left: 20),
                    child: TextField(
                      style: TextStyle(color: AppColor.white),
                      controller: controller,
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
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.network(
                                converter?.youtubeModel?.image ?? '',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(converter?.youtubeModel?.title ?? '',
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
                  Center(
                    child: FlatButton(
                      color: Colors.grey,
                        onPressed: ()async{
                        final status = await Permission.storage.request();

                        if(status.isGranted){

                          final externalDir = await getExternalStorageDirectory();

                          final id = await FlutterDownloader.enqueue(
                              url: "https://youtubeaudio.com/"+converter?.youtubeModel?.url,
                              savedDir: externalDir.path,
                              fileName: converter?.youtubeModel?.title,
                          showNotification: true,
                          openFileFromNotification: true);
                        } else{
                          print('Permission denied');
                        }
                      // _downloadFileToStorage(context, url, "mp3 File.mp3");
                    }, child: Text('Download',
                    style: TextStyle(color: AppColor.white),)),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Expanded(
                      //   child: Column(
                      //     children: [
                      //       downloadButton(fileDownloaderProvider),
                      //       downloadProgress()
                      //     ],
                      //   ),
                      // ),
                      FlatButton(
                          onPressed: () { _download();
                          // setState(() {
                          //   url = controller.text;
                          // });
                          },
                          color: Colors.green,
                          child: Text(
                            'Download',
                            style: TextStyle(color: Colors.white, fontSize: 20),
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
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sign Up',
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.w800),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.w800),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

  }

  void _download() {
    _converterProvider.convert('${controller.text}');
  }
}
