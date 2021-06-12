import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/database/repository/song_repository.dart';
import 'package:mp3_music_converter/screens/song/song_view.dart';
import 'package:mp3_music_converter/screens/splitted/sing_along.dart';
import 'package:mp3_music_converter/screens/splitted/split_songs.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:permission_handler/permission_handler.dart';

bool debug = true;

class Downloads extends StatefulWidget {
  final List apiSplittedList;
  final Song song;
  final Map convert;
  final String localPath;

  Downloads({this.apiSplittedList, this.convert, this.localPath, this.song});
  @override
  _DownloadsState createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {
  List<DownloadTask> downloads = [];
  ReceivePort _port = ReceivePort();
  List<dynamic> dataList = [];
  List<String> _apiSplittedList = ['', ''];
  List<String> splittedSongIDList = ['', ''];
  Map songData = {};
  static String _localPath;
  Timer _timer;

  init() async {
    if (widget.apiSplittedList != null && widget.apiSplittedList.isNotEmpty) {
      _apiSplittedList = widget.apiSplittedList;
      _localPath = widget.localPath;

      await _requestDownload(
          link: _apiSplittedList[0],
          saveToDownload: true,
          fileName: widget.song.fileName);
      await _requestDownload(
          link: _apiSplittedList[1],
          saveToDownload: true,
          fileName: widget.song.fileName);
    } else if (widget.convert != null && widget.convert.isNotEmpty) {
      _localPath = widget.localPath;
      songData = widget.convert;
      String fileName = getStringPathName(widget.convert['url']);
      final status = await Permission.storage.request();

      if (status.isGranted) {
        var downloadPath = await DownloadsPathProvider.downloadsDirectory;
        _localPath = downloadPath.path;
        bool exists =
            await File(_localPath + Platform.pathSeparator + fileName).exists();

        if (!exists) {
          await SplittedSongRepository.addDownload(
              key: fileName,
              song: Song(
                  image: widget.convert['image'],
                  artistName: widget.convert['artist'],
                  songName: widget.convert['song']));
          await FlutterDownloader.registerCallback(downloadCallback);
          await FlutterDownloader.enqueue(
              url: widget.convert['url'],
              savedDir: _localPath,
              fileName: fileName,
              headers: {"auth": "test_for_sql_encoding"},
              showNotification: true,
              openFileFromNotification: false);
        } else
          showToast(context, message: 'File already exists');
      }
    }
    downloads = await FlutterDownloader.loadTasks();
    setState(() {});
  }

  @override
  void initState() {
    IsolateNameServer.removePortNameMapping('audio_downloader');
    _bindBackgroundIsolate();
    init();
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() async {
    const time = const Duration(milliseconds: 500);
    _timer = new Timer.periodic(time, (timer) async {
      downloads = await FlutterDownloader.loadTasks();
      if (mounted) setState(() {});
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
        dataList.add(data);
      }
      DownloadTaskStatus status = data[1];

      if (status == DownloadTaskStatus.complete ||
          status == DownloadTaskStatus(3)) {
        DownloadTask specificDownload = downloads.firstWhere(
            (element) => element.taskId.toString() == data[0].toString());

        String name = specificDownload.filename;
        String splittedName = name.split('-').last;
        Song song = splittedName == 'accompaniment.wav' ||
                splittedName == 'vocals.wav'
            ? await SplittedSongRepository.getDownload(splitFileNameHere(name))
            : await SplittedSongRepository.getDownload(name);
        String path = specificDownload.savedDir;
        if (splittedName == 'accompaniment.wav')
          await SplittedSongRepository.addSong(Song(
            fileName: name,
            filePath: path,
            image: song.image ?? '',
            splittedFileName: splitFileNameHere(name),
            artistName: song.artistName ?? 'Unknown Artist',
            songName: song.songName ?? 'Unknown',
          ));
        else if (splittedName == 'vocals.wav')
          await SplittedSongRepository.addSong(Song(
            vocalName: name,
            filePath: path,
            image: song.image ?? '',
            splittedFileName: splitFileNameHere(name),
            artistName: song.artistName ?? 'Unknown Artist',
            songName: song.songName ?? 'Unknown',
          ));
        else
          await SongRepository.addSong(Song(
            fileName: name,
            songName: song.songName ?? 'Unknown',
            artistName: song.artistName ?? 'Unknown Artist',
            filePath: path,
            image: song.image ?? '',
            favorite: false,
            lastPlayDate: DateTime.now(),
          ));
      }
    });
  }

  String splitFileNameHere(String fileName) {
    List name = fileName.split('-');
    name.removeLast();
    return name.join('-');
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) async {
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
      if (saveToDownload == true) {
        var downloadPath = await DownloadsPathProvider.downloadsDirectory;
        _localPath = downloadPath.path;
      }
      String _fileName = fileName + '-' + getStringPathName(link);

      bool exists =
          await File(_localPath + Platform.pathSeparator + _fileName).exists();

      if (exists)
        showToast(context, message: 'File already exists');
      else {
        await SplittedSongRepository.addDownload(
            key: fileName,
            song: Song(
                image: widget.song.image,
                artistName: widget.song.artistName,
                songName: widget.song.songName));
        await FlutterDownloader.registerCallback(downloadCallback);
        await FlutterDownloader.enqueue(
            url: link,
            headers: {"auth": "test_for_sql_encoding"},
            savedDir: _localPath,
            fileName: _fileName,
            showNotification: true,
            openFileFromNotification: true);
      }
    }
  }

  String message(DownloadTaskStatus status) {
    if (status == DownloadTaskStatus(1)) return 'Pending';
    if (status == DownloadTaskStatus(2)) return 'Downloading';
    if (status == DownloadTaskStatus(3)) return 'Download Complete';
    if (status == DownloadTaskStatus(4)) return 'Download Failed';
    if (status == DownloadTaskStatus(5)) return 'Download Canceled';
    if (status == DownloadTaskStatus(6)) return 'Download Paused';
    return 'Unknown Status';
  }

  void removeDownloads() async {
    List<DownloadTask> allDownloads = await FlutterDownloader.loadTasks();
    allDownloads.forEach((element) {
      if (element.status != DownloadTaskStatus(2) &&
          element.status != DownloadTaskStatus(6) &&
          element.status != DownloadTaskStatus(1)) {
        FlutterDownloader.remove(taskId: element.taskId);
      }
    });
    setState(() {});
  }

  Future<bool> checkName(DownloadTask task) async {
    List<DownloadTask> downloads = await FlutterDownloader.loadTasks();
    List downloadName = task.filename.split('-');
    downloadName.removeLast();
    bool bothDownloaded = downloads.any((element) =>
        element.filename == downloadName.join('-') + '-accompaniment.wav');
    return bothDownloaded;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.black,
        title: TextViewWidget(
          text: 'Downloads',
          color: AppColor.bottomRed,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: AppColor.bottomRed,
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                showConfirmClear();
              },
              child: Text(
                'Clear',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ))
        ],
      ),
      body: downloads == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : downloads.isEmpty
              ? Center(
                  child: Text(
                    'No Downloads',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColor.white,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: downloads.length,
                  itemBuilder: (context, value) {
                    int index = downloads.length - 1 - value;
                    DownloadTask _download = downloads[index];
                    return InkWell(
                      onTap: _download.status == DownloadTaskStatus(3)
                          ? () async {
                              int width =
                                  MediaQuery.of(context).size.width.floor();
                              if (_download.filename.split('-').last ==
                                  'accompaniment.wav')
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => SplittedScreen()));
                              else if (_download.filename.split('-').last ==
                                      'vocals.wav' &&
                                  await checkName(_download))
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => SingAlong()));
                              else if (_download.filename.split('-').last ==
                                      'vocals.wav' &&
                                  !(await checkName(_download)))
                                showToast(context,
                                    message:
                                        'Please download the \'accompaniment.wav\' file for this song');
                              else
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SongViewCLass(width)));
                            }
                          : null,
                      child: Column(
                        children: [
                          if (index == downloads.length - 1)
                            SizedBox(height: 10),
                          ListTile(
                            title: Text(
                              _download.filename,
                              style: TextStyle(color: AppColor.white),
                            ),
                            trailing: _download.status ==
                                        DownloadTaskStatus(3) ||
                                    _download.status == DownloadTaskStatus(5) ||
                                    _download.status == DownloadTaskStatus(0)
                                ? null
                                : _download.status == DownloadTaskStatus(4)
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.replay,
                                          color: AppColor.white,
                                          size: 30,
                                        ),
                                        onPressed: () async {
                                          await FlutterDownloader.retry(
                                              taskId: _download.taskId);
                                          await FlutterDownloader
                                              .registerCallback(
                                                  downloadCallback);
                                        },
                                      )
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          if (_download.status ==
                                                  DownloadTaskStatus(2) ||
                                              _download.status ==
                                                  DownloadTaskStatus(6))
                                            IconButton(
                                                icon: Icon(
                                                  _download.status ==
                                                          DownloadTaskStatus(6)
                                                      ? Icons.play_arrow
                                                      : Icons.pause,
                                                  color: AppColor.white,
                                                  size: 30,
                                                ),
                                                onPressed: () async {
                                                  if (_download.status ==
                                                      DownloadTaskStatus(6)) {
                                                    await FlutterDownloader
                                                        .resume(
                                                            taskId: _download
                                                                .taskId);
                                                    await FlutterDownloader
                                                        .registerCallback(
                                                            downloadCallback);
                                                  } else
                                                    await FlutterDownloader
                                                        .pause(
                                                            taskId: _download
                                                                .taskId);
                                                }),
                                          IconButton(
                                              icon: Icon(
                                                Icons.stop,
                                                color: AppColor.white,
                                                size: 30,
                                              ),
                                              onPressed: () async {
                                                await FlutterDownloader.cancel(
                                                    taskId: _download.taskId);
                                              })
                                        ],
                                      ),
                          ),
                          SizedBox(height: 10),
                          if (_download.status == DownloadTaskStatus(2))
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: LinearProgressIndicator(
                                backgroundColor: Colors.grey,
                                valueColor: AlwaysStoppedAnimation(Colors.blue),
                                value: _download.progress / 100,
                              ),
                            ),
                          Text(
                            _download.status == DownloadTaskStatus(2)
                                ? message(_download.status) +
                                    '  ${_download.progress}%'
                                : message(_download.status),
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(height: 8),
                          if (index != 0)
                            Divider(
                              color: AppColor.white,
                              height: 0,
                            ),
                          if (index == 0) SizedBox(height: 10),
                        ],
                      ),
                    );
                  }),
    );
  }

  Future<void> showConfirmClear() {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            backgroundColor: Color.fromRGBO(40, 40, 40, 1),
            content: Text(
              'This would clear all download history for completed and failed files.\n\nProceed?',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('No',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500))),
              TextButton(
                  onPressed: () {
                    removeDownloads();
                    Navigator.pop(context);
                  },
                  child: Text('Yes',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500)))
            ],
          );
        });
  }
}
