import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart' as fd;
import 'package:audio_session/audio_session.dart' as asp;
import 'package:hive/hive.dart';
import 'package:hive_listener/hive_listener.dart';
import 'package:mp3_music_converter/chat/chat_home.dart';
import 'package:mp3_music_converter/chat/database_service.dart';
import 'package:mp3_music_converter/chat/show_image.dart';
import 'package:mp3_music_converter/screens/song/provider/music_provider.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String peerName;
  final String imageUrl;
  final String id;
  final String pid;
  ChatScreen(
      {@required this.imageUrl,
      @required this.peerName,
      @required this.id,
      @required this.pid,
      Key key})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _textController;
  ScrollController _scrollController;
  Box _taskBox;
  String groupId;
  ReceivePort _port = ReceivePort();
  static String _localPath;
  int docLength = 0;
  StreamSubscription messageStream;
  List messages = [];
  AudioPlayer _player;
  String currentlyPlaying;
  Duration totalDuration = Duration(seconds: 0);
  Duration progress = Duration(seconds: 0);
  AudioPlayerState _playerState = AudioPlayerState.STOPPED;
  asp.AudioSession audioSession;

  @override
  void initState() {
    _taskBox = Hive.box('task');
    initAudioPlayer();
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    _bindBackgroundIsolate();
    _textController = TextEditingController();
    _scrollController = ScrollController();
    getStream(widget.id, widget.pid);

    Timer(
        Duration(milliseconds: 600),
        () => _scrollController
            .jumpTo(_scrollController.position.maxScrollExtent));
    super.initState();
  }

  initAudioPlayer() {
    _player = AudioPlayer();
    _player.onDurationChanged.listen((event) {
      if (mounted)
        setState(() {
          totalDuration = event;
        });
    });
    _player.onAudioPositionChanged.listen((event) {
      if (mounted)
        setState(() {
          progress = event;
        });
    });
    _player.onPlayerStateChanged.listen((event) {
      if (mounted)
        setState(() {
          _playerState = event;
        });
      if (event == AudioPlayerState.COMPLETED) {
        progress = Duration(seconds: 0);
        totalDuration = Duration(seconds: 0);
        currentlyPlaying = null;
        if (mounted) setState(() {});
      }
    });
    _player.onPlayerError.listen((event) {
      showToast(context,
          message: 'File not found', backgroundColor: Colors.red, gravity: 1);
    });
  }

  getStream(String id, String peerId) {
    messageStream = DatabaseService().chatStream(id, peerId).listen((event) {
      List userMessages = [];
      if (event != null) {
        Map data = event.snapshot.value;

        if (data != null) {
          data.forEach((key, value) {
            if (key != 'name' && key != 'time' && key != 'lastMessage')
              userMessages.add(value);
          });

          userMessages.sort((a, b) => a['time'].compareTo(b['time']));

          setState(() {
            messages = userMessages;
          });
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      }
    });
  }

  String splitFileNameHere(String fileName, String key) {
    List name = fileName.split('.');
    String last = name.removeLast();
    return name.join('.') + '__$key' + '__.$last';
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'audio_downloader');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) async {
      fd.DownloadTaskStatus status = data[1];

      if (status == fd.DownloadTaskStatus.running ||
          status == fd.DownloadTaskStatus(2)) {
        List<fd.DownloadTask> downloads =
            await fd.FlutterDownloader.loadTasks();
        fd.DownloadTask specificDownload = downloads.firstWhere(
            (element) => element.taskId.toString() == data[0].toString());

        List splitName = specificDownload.filename.split('__');

        String key = splitName.elementAt(splitName.length - 2);

        Hive.box('task').put(key, {
          'downloaded': false,
          'progress': data[2],
          'id': data[0],
          'cancelled': false
        });
      }

      if (status == fd.DownloadTaskStatus.canceled ||
          status == fd.DownloadTaskStatus(5)) {
        fd.FlutterDownloader.remove(taskId: data[0]);
      }

      if (status == fd.DownloadTaskStatus.complete ||
          status == fd.DownloadTaskStatus(3)) {
        List<fd.DownloadTask> downloads =
            await fd.FlutterDownloader.loadTasks();
        fd.DownloadTask specificDownload = downloads.firstWhere(
            (element) => element.taskId.toString() == data[0].toString());

        List splitName = specificDownload.filename.split('__');

        String key = splitName.elementAt(splitName.length - 2);

        String path = specificDownload.savedDir;
        await Hive.box('task').put(key, {
          'downloaded': true,
          'path': path,
          'name': specificDownload.filename,
          'cancelled': false
        });
        await fd.FlutterDownloader.remove(taskId: specificDownload.taskId);
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('audio_downloader');
  }

  static void downloadCallback(
      String id, fd.DownloadTaskStatus status, int progress) async {
    final SendPort send =
        IsolateNameServer.lookupPortByName('audio_downloader');
    send.send([id, status, progress]);
  }

  downloadAudio(String url, String name, String key) async {
    final status = await Permission.storage.request();

    if (status.isGranted) {
      var downloadPath = await DownloadsPathProvider.downloadsDirectory;
      _localPath = downloadPath.path;
      await fd.FlutterDownloader.registerCallback(downloadCallback);
      await fd.FlutterDownloader.enqueue(
          url: url,
          savedDir: _localPath,
          fileName: splitFileNameHere(name, key),
          showNotification: false);
    }
  }

  @override
  void dispose() {
    messageStream?.cancel();
    if (_playerState == AudioPlayerState.PAUSED ||
        _playerState == AudioPlayerState.PLAYING) _player?.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        toolbarHeight: 70,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: AppColor.bottomRed,
          ),
        ),
        title: Row(
          children: [
            ClipOval(
              child: Container(
                width: 50,
                height: 50,
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, index) => Container(
                    child: Center(
                        child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator())),
                  ),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                ),
              ),
            ),
            SizedBox(width: 20),
            Text(widget.peerName),
          ],
        ),
        backgroundColor: AppColor.black,
      ),
      body: Theme(
        data: Theme.of(context).copyWith(accentColor: Colors.transparent),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: messages.length,
                controller: _scrollController,
                addAutomaticKeepAlives: true,
                cacheExtent: 10000000000.0,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      if (index == 0) checkDateForFirstMessage(messages[0]),
                      messages[index]['id'] == widget.id
                          ? _buildOutgoingMessages(messages[index], width)
                          : _buildIncomingMessages(messages[index], width)
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return checkDates(data: messages, index: index);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: decoration.copyWith(
                          hintText: 'Say something...',
                          suffixIcon: IconButton(
                              icon: Icon(
                                Icons.attachment,
                                color: AppColor.black,
                              ),
                              onPressed: () {
                                showAttachmentButtomSheet();
                              })),
                      cursorColor: AppColor.black,
                      cursorHeight: 18,
                      maxLines: 3,
                      minLines: 1,
                      textCapitalization: TextCapitalization.sentences,
                      controller: _textController,
                      onTap: () async {
                        await Future.delayed(Duration(milliseconds: 500));
                        _scrollController
                            .jumpTo(_scrollController.position.maxScrollExtent);
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () async {
                      if (_textController.text.trim().isNotEmpty) {
                        String data = _textController.text.trim();
                        _textController.clear();
                        DatabaseReference path = FirebaseDatabase.instance
                            .reference()
                            .child('messages')
                            .child(widget.id)
                            .child(widget.pid)
                            .push();

                        await DatabaseService().sendMessage(
                            message: data,
                            id: widget.id,
                            path: path,
                            type: 'text',
                            peerId: widget.pid);

                        _scrollController
                            .jumpTo(_scrollController.position.maxScrollExtent);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(212, 14, 14, 1),
                          shape: BoxShape.circle),
                      child: Icon(
                        Icons.arrow_forward_sharp,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildIncomingMessages(message, double width) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(message['time']);
    String _time = DateFormat.Hm().format(time).toString();

    if (message['read'] == false)
      DatabaseService()
          .updateRead(key: message['key'], id: widget.id, peerId: widget.pid);

    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 10),
          Icon(
            Icons.person_outlined,
            color: AppColor.white,
            size: 18,
          ),
          SizedBox(width: 5),
          Stack(
            children: [
              if (message['type'] == 'text')
                Container(
                  constraints:
                      BoxConstraints(maxWidth: 0.7 * width, minWidth: 100),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(1),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message['message'],
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              if (message['type'] == 'image' && message['message'] != '')
                Container(
                  width: 0.7 * width,
                  height: 200,
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 15),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(1),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ShowImage(
                                    name: message['name'],
                                    photoUrl: message['message'],
                                    heroKey: message['key'],
                                    showSave: true,
                                  )));
                    },
                    child: Hero(
                      tag: message['key'],
                      child: CachedNetworkImage(
                        imageUrl: message['message'],
                        fit: BoxFit.cover,
                        progressIndicatorBuilder: (context, value, progress) {
                          return Stack(alignment: Alignment.center, children: [
                            Container(
                              child: Image.asset('assets/youtubeaudiologo.png'),
                            ),
                            Container(
                              color: Colors.white.withOpacity(0.98),
                            ),
                            Container(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.blue),
                                  value: progress.progress ?? 0),
                            ),
                          ]);
                        },
                        errorWidget: (context, _, __) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                child:
                                    Image.asset('assets/youtubeaudiologo.png'),
                              ),
                              Container(
                                color: Colors.white.withOpacity(0.95),
                              ),
                              IconButton(
                                icon: Icon(Icons.download_outlined,
                                    size: 45, color: Colors.black54),
                                onPressed: () {},
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              if (message['type'] == 'audio' && message['message'] != '')
                Container(
                  width: 0.7 * width,
                  height: 80,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(1),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 15),
                  child: Container(
                    color: Colors.black12,
                    child: Row(
                      children: [
                        Container(
                          height: 60,
                          width: 50,
                          color: Colors.blue,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.headset,
                                  color: Colors.white, size: 38),
                              if ((_playerState == AudioPlayerState.PAUSED ||
                                      _playerState ==
                                          AudioPlayerState.PLAYING) &&
                                  currentlyPlaying == message['key'])
                                TextViewWidget(
                                  text: showPlayingDuration(),
                                  textSize: 16,
                                  textAlign: TextAlign.center,
                                  color: AppColor.white,
                                ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    child: HiveListener(
                                      box: _taskBox,
                                      builder: (box) {
                                        Map value = box.get(message['key']);
                                        return value == null
                                            ? IconButton(
                                                splashRadius: 30,
                                                icon: Icon(
                                                  Icons.download_outlined,
                                                  color: Colors.black54,
                                                  size: 25,
                                                ),
                                                onPressed: () {
                                                  box.put(message['key'], {
                                                    'downloaded': false,
                                                    'cancelled': false,
                                                    'progress': 0
                                                  });

                                                  downloadAudio(
                                                      message['message'],
                                                      message['name'],
                                                      message['key']);
                                                })
                                            : value['downloaded'] == false
                                                ? Container(
                                                    child: Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        Container(
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          child:
                                                              CircularProgressIndicator(
                                                            valueColor:
                                                                AlwaysStoppedAnimation(
                                                                    AppColor
                                                                        .blue),
                                                            value: double.parse(
                                                                    (value['progress'])
                                                                        .toString()) /
                                                                100,
                                                            backgroundColor:
                                                                Colors.white,
                                                            strokeWidth: 2,
                                                          ),
                                                        ),
                                                        IconButton(
                                                          splashRadius: 30,
                                                          icon: Icon(
                                                              Icons.close,
                                                              color: Colors
                                                                  .black54,
                                                              size: 25),
                                                          onPressed: () {
                                                            fd.FlutterDownloader
                                                                .cancel(
                                                                    taskId: value[
                                                                        'id']);
                                                            box.delete(
                                                                message['key']);
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                : InkWell(
                                                    onTap: () async {
                                                      playAudioFile(
                                                          message['key'],
                                                          value['path'] +
                                                              Platform
                                                                  .pathSeparator +
                                                              value['name']);
                                                    },
                                                    child: Icon(
                                                      currentlyPlaying ==
                                                                  message[
                                                                      'key'] &&
                                                              _playerState ==
                                                                  AudioPlayerState
                                                                      .PLAYING
                                                          ? Icons.pause
                                                          : Icons
                                                              .play_arrow_rounded,
                                                      size: 35,
                                                    ),
                                                  );
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                        height: 40,
                                        padding: EdgeInsets.only(left: 10),
                                        child: SliderTheme(
                                          data: SliderTheme.of(context)
                                              .copyWith(
                                                  trackHeight: 3,
                                                  activeTrackColor: Colors.blue,
                                                  inactiveTrackColor:
                                                      Colors.blue[100],
                                                  thumbColor: Colors.blue,
                                                  disabledActiveTrackColor:
                                                      Colors.blue,
                                                  disabledInactiveTrackColor:
                                                      Colors.blue[100],
                                                  disabledThumbColor:
                                                      Colors.blue,
                                                  thumbShape:
                                                      RoundSliderThumbShape(
                                                          enabledThumbRadius:
                                                              6),
                                                  overlayShape:
                                                      SliderComponentShape
                                                          .noOverlay),
                                          child: Slider(
                                            value: currentlyPlaying ==
                                                    message['key']
                                                ? progress.inSeconds.toDouble()
                                                : 0.0,
                                            min: 0.0,
                                            max: currentlyPlaying ==
                                                    message['key']
                                                ? totalDuration.inSeconds
                                                    .toDouble()
                                                : 0.0,
                                            onChanged: (val) {
                                              if (currentlyPlaying ==
                                                  message['key']) {
                                                _player.seek(Duration(
                                                    seconds: val.toInt()));
                                              }
                                            },
                                          ),
                                        )),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  message['name'],
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              Positioned(
                  bottom: 1,
                  right: 5,
                  child: Text(
                    _time,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOutgoingMessages(message, double width) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(message['time']);
    String _time = DateFormat.Hm().format(time).toString();
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment:
            message['read'] ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Spacer(),
          Stack(
            children: [
              if (message['type'] == 'text')
                Container(
                  constraints:
                      BoxConstraints(maxWidth: 0.7 * width, minWidth: 100),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message['message'],
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10)
                    ],
                  ),
                ),
              if (message['type'] == 'image')
                Stack(
                  children: [
                    Container(
                        width: 0.7 * width,
                        height: 200,
                        padding: EdgeInsets.fromLTRB(5, 5, 5, 15),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(1),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ShowImage(
                                          name: message['name'],
                                          photoUrl:
                                              message['message'] != null &&
                                                      message['message'] != ''
                                                  ? message['message']
                                                  : message['filePath'],
                                          heroKey: message['key'],
                                          network: message['message'] != null &&
                                              message['message'] != '',
                                        )));
                          },
                          child: Hero(
                            tag: message['key'],
                            child: Image.file(
                              File(message['filePath']),
                              fit: BoxFit.cover,
                              gaplessPlayback: true,
                              errorBuilder: (context, object, stackTrace) {
                                return CachedNetworkImage(
                                  imageUrl: message['message'],
                                  fit: BoxFit.cover,
                                  progressIndicatorBuilder:
                                      (context, value, progress) {
                                    return Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            child: Image.asset(
                                                'assets/youtubeaudiologo.png'),
                                          ),
                                          Container(
                                            color:
                                                Colors.white.withOpacity(0.98),
                                          ),
                                          Container(
                                            height: 50,
                                            width: 50,
                                            child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                        Colors.blue),
                                                value: progress.progress ?? 0),
                                          ),
                                        ]);
                                  },
                                  errorWidget: (context, _, __) {
                                    return Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          child: Image.asset(
                                              'assets/youtubeaudiologo.png'),
                                        ),
                                        Container(
                                          color: Colors.white.withOpacity(0.95),
                                        ),
                                        Text('Could not load',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16))
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        )),
                    HiveListener(
                      box: _taskBox,
                      builder: (box) {
                        Map value = box.get(message['key']);
                        return value != null && value['status'] != 'completed'
                            ? Container(
                                width: 0.7 * width,
                                height: 200,
                                color: Colors.white.withOpacity(0.5),
                                padding: EdgeInsets.fromLTRB(5, 5, 5, 15),
                                alignment: Alignment.center,
                                child: value['status'] == 'uploading'
                                    ? Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            height: 40,
                                            width: 40,
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                      AppColor.blue),
                                              value: double.parse(
                                                  (value['progress'])
                                                      .toString()),
                                            ),
                                          ),
                                          IconButton(
                                              icon: Icon(Icons.close,
                                                  color: Colors.black,
                                                  size: 30),
                                              onPressed: () {
                                                _taskBox.put(message['key'],
                                                    {'cancel': true});
                                              })
                                        ],
                                      )
                                    : IconButton(
                                        icon: Icon(
                                          Icons.upload_outlined,
                                          color: Colors.black54,
                                          size: 50,
                                        ),
                                        onPressed: () {
                                          showFilePicker(
                                            retry: true,
                                            key: message['key'],
                                            fileName: message['name'],
                                            filePath: message['filePath'],
                                          );
                                        }))
                            : SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              if (message['type'] == 'audio')
                Container(
                  width: 0.7 * width,
                  height: 80,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(1),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 15),
                  child: Container(
                    color: Colors.black12,
                    child: Row(
                      children: [
                        Container(
                          height: 60,
                          width: 50,
                          color: Colors.blue,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.headset,
                                  color: Colors.white, size: 38),
                              if ((_playerState == AudioPlayerState.PAUSED ||
                                      _playerState ==
                                          AudioPlayerState.PLAYING) &&
                                  currentlyPlaying == message['key'])
                                TextViewWidget(
                                  text: showPlayingDuration(),
                                  textSize: 16,
                                  textAlign: TextAlign.center,
                                  color: AppColor.white,
                                ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    child: HiveListener(
                                        box: _taskBox,
                                        builder: (box) {
                                          Map value = box.get(message['key']);
                                          return value != null
                                              ? Container(
                                                  child: value['status'] ==
                                                          'uploading'
                                                      ? Stack(
                                                          alignment:
                                                              Alignment.center,
                                                          children: [
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle),
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(5),
                                                              child:
                                                                  CircularProgressIndicator(
                                                                valueColor:
                                                                    AlwaysStoppedAnimation(
                                                                        AppColor
                                                                            .blue),
                                                                value: double
                                                                    .parse((value[
                                                                            'progress'])
                                                                        .toString()),
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                strokeWidth: 2,
                                                              ),
                                                            ),
                                                            IconButton(
                                                                splashRadius:
                                                                    30,
                                                                icon: Icon(
                                                                    Icons.close,
                                                                    color: Colors
                                                                        .black54,
                                                                    size: 25),
                                                                onPressed: () {
                                                                  _taskBox.put(
                                                                      message[
                                                                          'key'],
                                                                      {
                                                                        'cancel':
                                                                            true
                                                                      });
                                                                })
                                                          ],
                                                        )
                                                      : value['status'] ==
                                                              'completed'
                                                          ? InkWell(
                                                              onTap: () async {
                                                                playAudioFile(
                                                                    message[
                                                                        'key'],
                                                                    message[
                                                                        'filePath']);
                                                              },
                                                              child: Icon(
                                                                currentlyPlaying ==
                                                                            message[
                                                                                'key'] &&
                                                                        _playerState ==
                                                                            AudioPlayerState
                                                                                .PLAYING
                                                                    ? Icons
                                                                        .pause
                                                                    : Icons
                                                                        .play_arrow_rounded,
                                                                size: 35,
                                                              ),
                                                            )
                                                          : IconButton(
                                                              splashRadius: 30,
                                                              icon: Icon(
                                                                Icons
                                                                    .upload_outlined,
                                                                color: Colors
                                                                    .black54,
                                                                size: 25,
                                                              ),
                                                              onPressed: () {
                                                                showFilePicker(
                                                                  retry: true,
                                                                  key: message[
                                                                      'key'],
                                                                  fileName:
                                                                      message[
                                                                          'name'],
                                                                  filePath: message[
                                                                      'filePath'],
                                                                );
                                                              }))
                                              : SizedBox.shrink();
                                        }),
                                  ),
                                  Expanded(
                                    child: Container(
                                        height: 40,
                                        padding: EdgeInsets.only(left: 10),
                                        child: SliderTheme(
                                          data: SliderTheme.of(context)
                                              .copyWith(
                                                  trackHeight: 3,
                                                  activeTrackColor: Colors.blue,
                                                  inactiveTrackColor:
                                                      Colors.blue[100],
                                                  thumbColor: Colors.blue,
                                                  disabledActiveTrackColor:
                                                      Colors.blue,
                                                  disabledInactiveTrackColor:
                                                      Colors.blue[100],
                                                  disabledThumbColor:
                                                      Colors.blue,
                                                  thumbShape:
                                                      RoundSliderThumbShape(
                                                          enabledThumbRadius:
                                                              6),
                                                  overlayShape:
                                                      SliderComponentShape
                                                          .noOverlay),
                                          child: Slider(
                                            value: currentlyPlaying ==
                                                    message['key']
                                                ? progress.inSeconds.toDouble()
                                                : 0.0,
                                            min: 0.0,
                                            max: currentlyPlaying ==
                                                    message['key']
                                                ? totalDuration.inSeconds
                                                    .toDouble()
                                                : 0.0,
                                            onChanged: (val) {
                                              if (currentlyPlaying ==
                                                  message['key']) {
                                                _player.seek(Duration(
                                                    seconds: val.toInt()));
                                              }
                                            },
                                          ),
                                        )),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  message['name'],
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Positioned(
                  bottom: 1,
                  right: 5,
                  child: Text(
                    _time,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ))
            ],
          ),
          SizedBox(width: 5),
          Icon(
            Icons.person_outlined,
            color:
                message['read'] ? Colors.green : Colors.white.withOpacity(0.8),
            size: 18,
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }

  String showPlayingDuration() {
    List currentProgress = progress.toString().split('.')[0].split(':');
    if (currentProgress[0] == '0') {
      currentProgress.removeAt(0);
      return currentProgress.join(':');
    }
    return currentProgress.join(':');
  }

  Widget checkDates({@required List data, @required int index}) {
    String currentItemDate = DateFormat.yMd()
        .format(DateTime.fromMillisecondsSinceEpoch(data[index]['time']));

    String currentItemDay = currentItemDate.split('/')[1];
    String currentItemMonth = currentItemDate.split('/')[0];
    String currentItemYear = currentItemDate.split('/')[2];

    String currentDate = DateFormat.yMd().format(DateTime.now());
    String currentDay = currentDate.split('/')[1];
    String currentMonth = currentDate.split('/')[0];
    String currentYear = currentDate.split('/')[2];

    String nextItemDate = index != data.length - 1
        ? DateFormat.yMd().format(
            DateTime.fromMillisecondsSinceEpoch(data[index + 1]['time']))
        : currentItemDate;
    String nextItemDay =
        index != data.length - 1 ? nextItemDate.split('/')[1] : currentItemDay;
    String nextItemMonth = index != data.length - 1
        ? nextItemDate.split('/')[0]
        : currentItemMonth;
    String nextItemYear =
        index != data.length - 1 ? nextItemDate.split('/')[2] : currentItemYear;
    String date = index != data.length - 1
        ? DateFormat.MMMMd().format(
                DateTime.fromMillisecondsSinceEpoch(data[index + 1]['time'])) +
            ' ' +
            DateFormat.y().format(
                DateTime.fromMillisecondsSinceEpoch(data[index + 1]['time']))
        : DateFormat.MMMMd().format(
                DateTime.fromMillisecondsSinceEpoch(data[index]['time'])) +
            ' ' +
            DateFormat.y().format(
                DateTime.fromMillisecondsSinceEpoch(data[index]['time']));

    if (currentItemDate != nextItemDate &&
        nextItemYear == currentYear &&
        nextItemMonth == currentMonth &&
        nextItemDay == currentDay)
      return buildSeparator('Today');
    else if (currentItemDate != nextItemDate &&
        nextItemYear == currentYear &&
        nextItemMonth == currentMonth &&
        int.parse(nextItemDay) == int.parse(currentDay) - 1)
      return buildSeparator('Yesterday');
    else if (currentItemDate != nextItemDate)
      return buildSeparator(date);
    else
      return SizedBox.shrink();
  }

  Widget buildSeparator(String data) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColor.red,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          data,
          style: TextStyle(
              color: AppColor.white, fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget checkDateForFirstMessage(docs) {
    String date = DateFormat.yMd()
        .format(DateTime.fromMillisecondsSinceEpoch(docs['time']));
    String currentDate = DateFormat.yMd().format(DateTime.now());
    String stringDate = DateFormat.MMMMd()
            .format(DateTime.fromMillisecondsSinceEpoch(docs['time'])) +
        ' ' +
        DateFormat.y()
            .format(DateTime.fromMillisecondsSinceEpoch(docs['time']));

    if (date == currentDate)
      return buildSeparator('Today');
    else if (date.split('/')[2] == currentDate.split('/')[2] &&
        date.split('/')[0] == currentDate.split('/')[0] &&
        int.parse(date.split('/')[1]) ==
            int.parse(currentDate.split('/')[1]) - 1)
      return buildSeparator('Yesterday');
    else
      return buildSeparator(stringDate);
  }

  showAttachmentButtomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          color: AppColor.black,
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(
                  Icons.image,
                  color: AppColor.white,
                  size: 30,
                ),
                title: Text(
                  'Image',
                  style: TextStyle(color: AppColor.white, fontSize: 17),
                ),
                onTap: () {
                  Navigator.pop(context);
                  showFilePicker(fileType: FileType.image);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.videocam,
                  color: AppColor.white,
                  size: 30,
                ),
                title: Text(
                  'Audio',
                  style: TextStyle(color: AppColor.white, fontSize: 17),
                ),
                onTap: () {
                  Navigator.pop(context);
                  showFilePicker(fileType: FileType.audio);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  showFilePicker({
    FileType fileType,
    bool retry = false,
    String filePath,
    String fileName,
    String key,
  }) async {
    FilePickerResult file;
    String selectedFileType;
    UploadTask uploadTask;
    if (!retry) {
      file = await FilePicker.platform.pickFiles(type: fileType);
      selectedFileType = fileType == FileType.image ? 'image' : 'audio';
    }

    if (file?.files != null || retry) {
      DatabaseReference path;

      if (!retry) {
        path = FirebaseDatabase.instance
            .reference()
            .child('messages')
            .child(widget.id)
            .child(widget.pid)
            .push();

        await DatabaseService().sendMessage(
          message: '',
          id: widget.id,
          type: selectedFileType,
          path: path,
          filePath: file.files.single.path,
          fileName: file.files.single.name,
          peerId: widget.pid,
        );
      }

      await _taskBox.put(retry ? key : path.key,
          {'progress': 0, 'status': 'uploading', 'cancel': false});

      final reference = FirebaseStorage.instance.ref().child('files').child(
          retry ? '-11-' + key + '-11-.jpg' : '-11-' + path.key + '-11-.jpg');

      uploadTask =
          reference.putFile(File(!retry ? file.files.single.path : filePath));

      uploadTask.snapshotEvents.listen((event) async {
        await _taskBox.put(retry ? key : path.key, {
          'progress': event.bytesTransferred / event.totalBytes,
          'status': 'uploading',
          'cancel': false
        });

        _taskBox?.watch(key: retry ? key : path.key)?.listen((event) async {
          if (event?.value != null && event?.value['cancel'] == true) {
            await uploadTask.cancel();
          }
        });
        if (event.state == TaskState.success) {
          String url = await event.ref.getDownloadURL();

          await _taskBox.put(url.split('-11-')[1],
              {'progress': 100, 'status': 'completed', 'cancel': false});
          await DatabaseService().updateMessage(
              message: url,
              key: retry ? key : path.key,
              id: widget.id,
              peerId: widget.pid);
        }
        if (event.state == TaskState.canceled) {
          print('this task has been cancelled');
          await _taskBox.put(retry ? key : path.key,
              {'progress': 0, 'status': 'failed', 'cancel': false});
        }
        if (event.state == TaskState.error)
          await _taskBox.put(retry ? key : path.key,
              {'progress': 0, 'status': 'failed', 'cancel': false});
      }, onError: (e) async {
        print('this task has been cancelled');
        await _taskBox.put(retry ? key : path.key,
            {'progress': 0, 'status': 'failed', 'cancel': false});
      });
    }
  }

  playAudioFile(String key, String path) async {
    audioSession = await asp.AudioSession.instance;
    audioSession
        .configure(asp.AudioSessionConfiguration.music())
        .then((session) async {
      handleInterruptions(audioSession);
      if (await audioSession.setActive(true)) {
        if (AudioService.playbackState.playing) {
          await AudioService.customAction(AudioPlayerTask.STOP);
          await AudioService.pause();
        }
        if (_playerState == AudioPlayerState.PLAYING && currentlyPlaying == key)
          await _player.pause();
        else if (_playerState == AudioPlayerState.PAUSED &&
            currentlyPlaying == key)
          await _player.resume();
        else {
          await _player.play(path, isLocal: true);
          setState(() {
            currentlyPlaying = key;
          });
        }
      }
    });
  }

  handleInterruptions(asp.AudioSession audioSession) {
    bool interrupted = false;
    audioSession.becomingNoisyEventStream?.listen((event) {
      _player.pause();
    });

    _player.onPlayerStateChanged.listen((event) {
      interrupted = false;
      if (event == AudioPlayerState.PLAYING) {
        audioSession.setActive(true);
      }
    });

    audioSession.interruptionEventStream.listen((event) async {
      if (event.begin) {
        if (_player.state == AudioPlayerState.PLAYING) {
          switch (event.type) {
            case asp.AudioInterruptionType.duck:
              if (audioSession.androidAudioAttributes.usage ==
                  asp.AndroidAudioUsage.game) await _player.setVolume(0.3);
              interrupted = false;
              break;
            case asp.AudioInterruptionType.pause:
            case asp.AudioInterruptionType.unknown:
              await _player.pause();
              interrupted = true;
              break;
          }
        }
      } else {
        switch (event.type) {
          case asp.AudioInterruptionType.duck:
            await _player.setVolume(1);
            interrupted = false;
            break;
          case asp.AudioInterruptionType.pause:
          case asp.AudioInterruptionType.unknown:
            if (interrupted) await _player.resume();
        }
      }
    });
  }
}
