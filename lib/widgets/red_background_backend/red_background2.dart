import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speech/flutter_speech.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/screens/song/provider/music_provider.dart';
import 'package:mp3_music_converter/screens/world_radio/radio_class.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:provider/provider.dart';
import 'package:mp3_music_converter/widgets/red_background_backend/provider.dart';
import 'package:mp3_music_converter/widgets/red_background_backend/cloud_storage.dart';

class RedBackground2 extends StatefulWidget {
  final String text;
  final IconButton iconButton;
  final VoidCallback callback;
  final Widget widgetContainer;
  final Function openRadio;

  RedBackground2(
      {this.text,
      this.iconButton,
      this.callback,
      this.widgetContainer,
      this.openRadio});

  @override
  _RedBackground2State createState() => _RedBackground2State();
}

class _RedBackground2State extends State<RedBackground2> {
  String url;
  SpeechRecognition _speech;
  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  MusicProvider _provider;
  bool oldUser = false;

  void onSpeechAvailability(bool result) {
    if (mounted) setState(() => _speechRecognitionAvailable = result);
  }

  void onRecognitionStarted() => setState(() => _isListening = true);
  void onRecognitionResult(String result) {}

  void onRecognitionComplete(String result) {
    if (mounted)
      setState(() {
        _isListening = false;
      });
    if (result != null) decideAction(result);
  }

  void cancel() {
    _speech.cancel().then((value) {
      if (mounted) setState(() => _isListening = false);
    });
  }

  void stop() {
    _speech.stop().then((value) {
      if (mounted) setState(() => _isListening = false);
    });
  }

  void start() {
    _speech.activate('en_US').then((_) {
      return _speech.listen().then((value) {
        if (mounted)
          setState(() {
            _isListening = value;
          });
      });
    });
  }

  void errorHandler() => activateSpeechRecognizer();

  void activateSpeechRecognizer() {
    _speech = SpeechRecognition();
    _speech.setAvailabilityHandler(onSpeechAvailability);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setErrorHandler(errorHandler);
    _speech.activate('en_US').then((value) {
      if (mounted) setState(() => _speechRecognitionAvailable = value);
    });
  }

  Future getImage(BuildContext context, bool isCamera) async {
    if (isCamera) {
      var picture = await ImagePicker().getImage(source: ImageSource.camera);
      if (picture != null && picture.path != null && picture.path.isNotEmpty) {
        File image = File(picture.path);
        CloudStorage().imageUploadAndDownload(image: image, context: context);
      }
    } else {
      var picture = await ImagePicker().getImage(source: ImageSource.gallery);
      if (picture != null && picture.path != null && picture.path.isNotEmpty) {
        File image = File(picture.path);
        CloudStorage().imageUploadAndDownload(image: image, context: context);
      }
    }
  }

  Future<void> _showDialog(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 8, 8),
                      child: TextViewWidget(
                        text: 'Camera',
                        color: AppColor.black,
                        textSize: 18,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      getImage(parentContext, true);
                    },
                  ),
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 8, 8, 0),
                      child: TextViewWidget(
                        text: 'Gallery',
                        color: AppColor.black,
                        textSize: 18,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      getImage(parentContext, false);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void decideAction(String input) async {
    input = input.trim().toLowerCase();
    await _provider.getSongs();

    if (input.contains('play song')) {
      final start = 'play song';
      final startIndex = input.indexOf(start);
      final end = 'by artist';

      int endIndex;
      if (input.contains(end)) endIndex = input.indexOf(end);

      final songName = endIndex == null
          ? input.substring(startIndex + start.length).trim()
          : input.substring(startIndex + start.length, endIndex).trim();

      final artistName = endIndex == null
          ? null
          : input.substring(endIndex + end.length).trim();

      Song _song = searchSong(artistName: artistName, songName: songName);
      if (_song.songName != null) {
        _provider.songs = [_song];
        _provider.playAudio(_song, force: true);
      }
      if (_song.songName == null)
        showToast(context, message: 'Could not find song', gravity: 2);
    } else if (input.contains('play radio')) {
      final start = 'play radio';
      final startIndex = input.indexOf(start);
      final channel = input.substring(startIndex + start.length).trim();

      if (channel != null && channel != '') widget.openRadio(channel);
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (_) => RadioClass(search: channel)));
    } else
      showToast(context, message: 'Invalid command', gravity: 2);
  }

  Song searchSong({@required String artistName, @required String songName}) {
    List<Song> allSongs = _provider.allSongs;
    Song _song = Song();

    if (artistName == null) {
      for (Song song in allSongs) {
        if (song.songName.toLowerCase() == songName.toLowerCase() ||
            song.songName.toLowerCase().contains(songName.toLowerCase())) {
          _song = song;
          break;
        }
      }
    } else {
      for (Song song in allSongs) {
        if ((song.songName.toLowerCase() == songName.toLowerCase() ||
                song.songName.toLowerCase().contains(songName.toLowerCase())) &&
            (song.artistName.toLowerCase() == artistName.toLowerCase() ||
                song.artistName
                    .toLowerCase()
                    .contains(artistName.toLowerCase()))) {
          _song = song;
          break;
        }
      }
    }
    return _song;
  }

  void init() async {
    oldUser = await preferencesHelper.doesExists(key: "oldUser");
  }

  @override
  void initState() {
    Provider.of<RedBackgroundProvider>(context, listen: false).getUrl();
    activateSpeechRecognizer();
    _provider = Provider.of<MusicProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    url = Provider.of<RedBackgroundProvider>(context).url;
    return Container(
      child: Stack(
        children: [
          Image.asset(
            AppAssets.background,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fitWidth,
          ),
          Container(
            margin: const EdgeInsets.only(left: 16, right: 16, top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    widget.iconButton != null
                        ? IconButton(
                            icon: widget.iconButton, onPressed: widget.callback)
                        : TextViewWidget(text: '', color: AppColor.transparent),
                    widget.text != null
                        ? TextViewWidget(
                            color: AppColor.white,
                            text: widget.text,
                            textSize: 22,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Montserrat')
                        : Image.asset(
                            AppAssets.dashlogo,
                            height: 63,
                          ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _widgetContainer(url),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isListening
                              ? Colors.black26
                              : Colors.transparent),
                      padding: EdgeInsets.all(5),
                      child: GestureDetector(
                        onTap: () async {
                          if (!(await preferencesHelper.doesExists(
                              key: "oldUser")))
                            showInstructions();
                          else if (_speechRecognitionAvailable && !_isListening)
                            start();
                          else
                            stop();
                        },
                        onLongPress: () {
                          showInstructions();
                        },
                        child: Icon(Icons.mic, size: 35, color: AppColor.white),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _widgetContainer(String picUrl) => InkWell(
        onTap: () async {
          await _showDialog(context);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            picUrl == null || picUrl == ''
                ? ClipOval(
                    child: SizedBox(
                        height: 50,
                        width: 50,
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                          placeholder: (context, url) =>
                              new CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              new Icon(Icons.error),
                        )),
                  )
                : ClipOval(
                    child: SizedBox(
                      width: 65,
                      height: 65,
                      child: CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.cover,
                        placeholder: (context, index) => Container(
                          color: Colors.white,
                          child: Center(
                              child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: CircularProgressIndicator())),
                        ),
                        errorWidget: (context, url, error) => Icon(
                          Icons.person,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                'Profile',
                style: TextStyle(
                    fontSize: 17,
                    color: AppColor.white,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Montserrat-Thin'),
              ),
            ),
          ],
        ),
      );

  showInstructions() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "To play a song, use the command",
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  "play song [name of song]",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "e.g play song The First Time",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 5),
                Text(
                  "or use the command",
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  "play song [name of song] by artist [name of artist]",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text("e.g play song The First Time by artist Isak Danielson"),
                SizedBox(height: 10),
                Text(
                  "To play a radio station, use the command",
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  "play radio [name of radio channel]",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "e.g play radio Love FM",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text("To see this instruction again, long press the mic icon")
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    preferencesHelper.saveValue(key: "oldUser", value: true);
                    init();
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Okay",
                    style: TextStyle(fontSize: 18),
                  ))
            ],
          );
        });
  }
}
