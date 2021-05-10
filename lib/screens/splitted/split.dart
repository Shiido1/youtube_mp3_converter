import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'dart:async';
import 'package:file/local.dart';
import 'package:file/file.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:mp3_music_converter/screens/recorded/provider/record_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:provider/provider.dart';
import 'package:mp3_music_converter/screens/recorded/recorder_services.dart';
import 'package:mp3_music_converter/screens/recorded/model/recorder_model.dart';

class Split extends StatefulWidget {
  final LocalFileSystem localFileSystem;
  Song song;

  Split({localFileSystem, @required this.song})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();
  @override
  _SplitState createState() => _SplitState();
}

class _SplitState extends State<Split> {
  AudioPlayer _splitFileAudioPlayer = AudioPlayer();
  AudioPlayer _recordingAudioPlayer = AudioPlayer();
  bool _splitAudioStatus = false;
  bool isSplitFilePlaying = false;
  String splitFileCurrentTime = "00:00";
  String recordCurrentTime = "00:00";
  Duration currentTime = Duration();
  Duration recordingCurrentTime = Duration();
  Duration maxTime = Duration();
  Duration recordingMaxTime = Duration();
  String splitFileCompleteTime = "00:00";
  String recordCompleteTime = "00:00";
  double val = 0.0;

  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;

  bool _isRecording = false;

  @override
  void initState() {
    _splitFileAudioPlayer.onAudioPositionChanged.listen((Duration duration) {
      setState(() {
        currentTime = duration;
        splitFileCurrentTime = duration.toString().split(".")[0];
      });
    });

    _splitFileAudioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        maxTime = duration;
        splitFileCompleteTime = duration.toString().split(".")[0];
      });
    });

    _recordingAudioPlayer.onAudioPositionChanged.listen((Duration duration) {
      setState(() {
        recordingCurrentTime = duration;
        recordCurrentTime = duration.toString().split(".")[0];
      });
    });

    _recordingAudioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        recordingMaxTime = duration;
        recordCompleteTime = duration.toString().split(".")[0];
      });
    });

    _init();
    super.initState();
  }

  @override
  void dispose() {
    _splitFileAudioPlayer.dispose();
    _recordingAudioPlayer.dispose();
    super.dispose();
  }

  _init() async {
    try {
      if (await FlutterAudioRecorder.hasPermissions) {
        String customPath = 'YoutubeMusicRecords';
        String date =
            "${DateTime.now()?.millisecondsSinceEpoch?.toString()}.wav";
        io.Directory appDocDirectory;
        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }

        io.Directory youtubeRecordDirectory = io.Directory(
            "${appDocDirectory.parent.parent.parent.parent.path}/$customPath/");

        if (await youtubeRecordDirectory.exists()) {
          String alphaPath = "${youtubeRecordDirectory.path}$date";
          _recorder =
              FlutterAudioRecorder(alphaPath, audioFormat: AudioFormat.WAV);

          await _recorder.initialized;

          var current = await _recorder.current(channel: 0);

          setState(() {
            _current = current;
            _currentStatus = current.status;
            print(_currentStatus);
          });
        } else {
          youtubeRecordDirectory.create(recursive: true);
          String alphaPath = "${youtubeRecordDirectory.path}$date";
          _recorder =
              FlutterAudioRecorder(alphaPath, audioFormat: AudioFormat.WAV);

          await _recorder.initialized;

          var current = await _recorder.current(channel: 0);

          setState(() {
            _current = current;
            _currentStatus = current.status;
            print(_currentStatus);
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  _start() async {
    try {
      await _recorder.start();
      var recording = await _recorder.current(channel: 0);

      setState(() {
        _current = recording;
        _isRecording = true;
      });

      const tick = const Duration(milliseconds: 50);
      new Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder.current(channel: 0);
        setState(() {
          _current = current;
          _currentStatus = _current.status;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  _resume() async {
    await _recorder.resume();
    setState(() {});
  }

  _stop() async {
    var result = await _recorder.stop();
    RecorderServices().addRecording(RecorderModel(path: result.path));
    print("Stop recording: ${result.path}");
    print("Stop recording: ${result.duration}");
    File file = widget.localFileSystem.file(result.path);
    print("File length: ${await file.length()}");
    setState(() {
      _current = result;
      _currentStatus = _current.status;
      _isRecording = false;
      //TODO: NEED TO DO SOMETHING ONCE RECORD IS STOPPED for noe pass it to a list
    });
  }

  IconData _buildIcon(RecordingStatus status) {
    IconData icon;
    switch (_currentStatus) {
      case RecordingStatus.Initialized:
        {
          icon = Icons.mic;
          break;
        }
      case RecordingStatus.Recording:
        {
          icon = Icons.stop;
          break;
        }
      case RecordingStatus.Paused:
        {
          icon = Icons.mic;
          break;
        }
      case RecordingStatus.Stopped:
        {
          icon = Icons.mic_none;
          break;
        }
      default:
        icon = Icons.mic;
        break;
    }
    return icon;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.grey,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: AppColor.white,
          ),
        ),
      ),
      body: Container(
        decoration: new BoxDecoration(
          color: AppColor.grey,
          image: new DecorationImage(
            fit: BoxFit.cover,
            colorFilter: new ColorFilter.mode(
                AppColor.black.withOpacity(0.5), BlendMode.dstATop),
            image: new AssetImage(
              AppAssets.bgImage2,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
                height: 250,
                width: 250,
                decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    image: new DecorationImage(
                      image: new AssetImage(AppAssets.image1),
                      fit: BoxFit.contain,
                    ))),
            SizedBox(
              height: 20,
            ),
            Center(
              child: TextViewWidget(
                text: widget.song.fileName ?? 'Something Fishy',
                color: AppColor.white,
                textSize: 18,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              width: 300,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextViewWidget(
                    text:
                        _isRecording ? recordCurrentTime : splitFileCurrentTime,
                    textSize: 16,
                    color: AppColor.white,
                    textAlign: TextAlign.center,
                  ),
                  //try and remove the expanded and see
                  Expanded(
                    child: Slider(
                        activeColor: AppColor.bottomRed,
                        inactiveColor: AppColor.white,
                        value: isSplitFilePlaying
                            ? currentTime.inSeconds.toDouble()
                            : _isRecording
                                ? recordingCurrentTime.inSeconds.toDouble()
                                : currentTime.inSeconds.toDouble(),
                        min: 0.0,
                        max: isSplitFilePlaying
                            ? maxTime.inSeconds.toDouble()
                            : _isRecording
                                ? recordingMaxTime.inSeconds.toDouble()
                                : maxTime.inSeconds.toDouble(),
                        onChanged: (double value) {
                          Duration newDuration =
                              Duration(seconds: value.toInt());
                          setState(() {
                            if (isSplitFilePlaying)
                              _splitFileAudioPlayer.seek(newDuration);
                            else
                              _recordingAudioPlayer.seek(newDuration);

                            val = value;
                          });
                        }),
                  ),
                  TextViewWidget(
                    text: _isRecording
                        ? recordCompleteTime
                        : splitFileCompleteTime,
                    textSize: 16,
                    textAlign: TextAlign.center,
                    color: AppColor.white,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      icon: Icon(
                          isSplitFilePlaying
                              ? Icons.pause_circle_outline_rounded
                              : Icons.play_circle_outline_rounded,
                          size: 65,
                          color: AppColor.white),
                      onPressed: () {
                        if (_isRecording)
                          setState(() {
                            _isRecording = false;
                            _recordingAudioPlayer.release();
                          });

                        if (isSplitFilePlaying && _splitAudioStatus) {
                          _splitFileAudioPlayer.pause();

                          setState(() {
                            isSplitFilePlaying = false;
                          });
                        } else if (!isSplitFilePlaying && _splitAudioStatus) {
                          _splitFileAudioPlayer.resume();

                          setState(() {
                            isSplitFilePlaying = true;
                          });
                        } else if (!isSplitFilePlaying && !_splitAudioStatus) {
                          _splitFileAudioPlayer
                              .play(widget.song.file, isLocal: true)
                              .then((value) {
                            if (value == 1) {
                              setState(() {
                                _splitAudioStatus = true;
                                isSplitFilePlaying = true;
                              });
                            } else {
                              print('couldn\'t play file');
                              setState(() {
                                _splitAudioStatus = false;
                                isSplitFilePlaying = false;
                              });
                            }
                          });
                        } else {
                          print('No Audio Selected');
                        }
                      }),
                  IconButton(
                      icon: Icon(
                        _buildIcon(_currentStatus),
                        size: 65,
                        color: AppColor.white,
                      ),
                      onPressed: () async {
                        if (isSplitFilePlaying)
                          setState(() {
                            isSplitFilePlaying = false;
                            _splitFileAudioPlayer.release();
                          });

                        switch (_currentStatus) {
                          case RecordingStatus.Initialized:
                            {
                              await _recordingAudioPlayer.play(widget.song.file,
                                  isLocal: true);
                              _start();
                              break;
                            }
                          case RecordingStatus.Recording:
                            {
                              _recordingAudioPlayer.stop();
                              //this can be changed to the pause method should there be a need for a seperate button
                              _stop();
                              break;
                            }
                          case RecordingStatus.Paused:
                            {
                              _recordingAudioPlayer.resume();
                              _resume();
                              break;
                            }
                          case RecordingStatus.Stopped:
                            {
                              _init();
                              break;
                            }
                          default:
                            break;
                        }
                      }),
                ],
              ),
            ),
            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
