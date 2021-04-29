// import 'dart:io';
// import 'dart:ui';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
// import 'dart:isolate';
//
// import 'package:path_provider/path_provider.dart';
//
//
// const String splitMusicPath = '.music';
// bool debug = true;
//
// class Download extends StatefulWidget with WidgetsBindingObserver{
//   final TargetPlatform platform;
//
//   Download({Key key, this.platform}) : super(key: key);
//
//   @override
//   _DownloadState createState() => _DownloadState();
// }
//
// class _DownloadState extends State<Download> {
//   bool loading = false;
//
//   int _progress = 0;
//
//   bool downloaded;
//
//   int id;
//
//   var val;
//
//   bool _isLoading;
//
//   bool _permissionReady;
//
//   ReceivePort _port = ReceivePort();
//
//   String _fileName;
//   static String _localPath;
//
//   @override
//   void dispose() {
//     _unbindBackgroundIsolate();
//     super.dispose();
//   }
//
//   void _bindBackgroundIsolate() {
//     bool isSuccess = IsolateNameServer.registerPortWithName(
//         _port.sendPort, 'downloader_send_port');
//     if (!isSuccess) {
//       _unbindBackgroundIsolate();
//       _bindBackgroundIsolate();
//       return;
//     }
//     _port.listen((dynamic data) async {
//       if (debug) {
//         print('UI Isolate Callback: $data');
//         dataList.add(data);
//       }
//
//       // ignore: unused_local_variable
//       String id = data[0];
//       DownloadTaskStatus status = data[1];
//
//       int progress = data[2];
//       setState(() {
//         _progress = progress;
//         loading = true;
//       });
//       if (_progress == 100) {
//         // _showDialog(context);
//         setState(() {
//           loading = false;
//         });
//       }
//       if (status == DownloadTaskStatus.complete) {
//         if(data[0].toString() == splittedSongIDList.first.toString()){
//           print('Data at index 0 is ${data[0].toString()}');
//           print('SplittedSongIDList at index 0 is ${splittedSongIDList.first.toString()}');
//           SplittedSongRepository.addSong(Song(
//             fileName: _fileName,
//             filePath: Download._localPath,
//             image: _musicProvider?.drawerItem?.image ?? '',
//             splittedFileName: _musicProvider?.drawerItem?.fileName ?? '',
//           ));
//
//           //Todo: delay a bit and then show a dialog or navigate to the
//         }
//       }
//     });
//
//   }
//
//   void _unbindBackgroundIsolate() {
//     IsolateNameServer.removePortNameMapping('downloader_send_port');
//   }
//
//
//   static void downloadCallback(
//       String id, DownloadTaskStatus status, int progress) async {
//     if (debug) {
//       print(
//           'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
//     }
//
//     final SendPort send =
//     IsolateNameServer.lookupPortByName('downloader_send_port');
//     send.send([id, status, progress]);
//   }
//
//   Future<void> _requestDownload(
//       {@required String link, bool saveToDownload = false}) async {
//     final status = await Permission.storage.request();
//
//     if (status.isGranted) {
//       if (saveToDownload) {
//         var downloadPath = await DownloadsPathProvider.downloadsDirectory;
//         _localPath = downloadPath.path;
//       }
//
//       _fileName = getStringPathName(link);
//       // setState(() {
//       //   downloaded = false;
//       // });
//       await FlutterDownloader.enqueue(
//           url: link,
//           headers: {"auth": "test_for_sql_encoding"},
//           savedDir: Download._localPath,
//           fileName: _fileName,
//           showNotification: true,
//           openFileFromNotification: true).then((value) => splittedSongIDList.add(value));
//     }
//   }
//
//   Future<bool> _checkPermission() async {
//     if (widget.platform == TargetPlatform.android) {
//       final status = await Permission.storage.status;
//       if (status != PermissionStatus.granted) {
//         final result = await Permission.storage.request();
//         if (result == PermissionStatus.granted) {
//           return true;
//         }
//       } else {
//         return true;
//       }
//     } else {
//       return true;
//     }
//     return false;
//   }
//
//   Future<Null> _prepare() async {
//     _permissionReady = await _checkPermission(); // checks for users permission
//
//     _localPath = (await _findLocalPath()) +
//         Platform.pathSeparator +
//         splitMusicPath; // gets users
//
//     final savedDir = Directory(Download._localPath);
//     bool hasExisted = await savedDir.exists();
//     if (!hasExisted) {
//       savedDir.create();
//     }
//
//     setState(() {
//       _isLoading = false;
//     });
//   }
//
//   Future<String> _findLocalPath() async {
//     final directory = widget.platform == TargetPlatform.android
//         ? await getExternalStorageDirectory()
//         : await getApplicationDocumentsDirectory();
//     return directory.path;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
