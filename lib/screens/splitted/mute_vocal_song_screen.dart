import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'dart:async';
import 'package:file/local.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:mp3_music_converter/screens/recorded/model/recorder_model.dart';
import 'package:mp3_music_converter/screens/recorded/recorded.dart';
import 'package:mp3_music_converter/screens/recorded/recorder_services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';

class MuteVocalsScreen extends StatefulWidget {
  final LocalFileSystem localFileSystem;
  final Song song;

  MuteVocalsScreen({localFileSystem, @required this.song})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  _MuteVocalsScreenState createState() => _MuteVocalsScreenState();
}

class _MuteVocalsScreenState extends State<MuteVocalsScreen> {
  AudioPlayer _instrumentalAudioPlayer = AudioPlayer();
  AudioPlayer _vocalAudioPlayer = AudioPlayer();

  bool _isPlaying = false;
  bool _isRecording = false;
  bool _playVocals = true;
  String recordingDuration = '0:00:00';

  String currentPlayingTime = "00:00";
  Duration currentTime = Duration();
  Duration maxTime = Duration();
  String playingCompleteTime = "00:00";

  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  StreamSubscription audioSuscription;
  StreamSubscription audioSuscription2;

  @override
  void initState() {
    audioSuscription = _instrumentalAudioPlayer.onAudioPositionChanged
        .listen((Duration duration) {
      if (duration >= Duration(milliseconds: 500) &&
          _currentStatus == RecordingStatus.Initialized &&
          _isPlaying == true &&
          _isRecording == true) _startRecorder();
      setState(() {
        currentTime = duration;
        currentPlayingTime = duration.toString().split(".")[0];
      });
      if (currentPlayingTime == playingCompleteTime) {
        setState(() {
          _isPlaying = false;
          currentPlayingTime = "00:00";
          currentTime = Duration();
        });
        if (_isRecording) _stopRecorder();
      }
    });

    audioSuscription2 =
        _instrumentalAudioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        maxTime = duration;
        playingCompleteTime = duration.toString().split(".")[0];
      });
    });

    _init();
    super.initState();
  }

  @override
  void dispose() {
    _instrumentalAudioPlayer.dispose();
    _vocalAudioPlayer.dispose();
    audioSuscription.cancel();
    audioSuscription2.cancel();
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
          _recorder = FlutterAudioRecorder(alphaPath,
              audioFormat: AudioFormat.WAV, sampleRate: 18000);

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

  _startRecorder() async {
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
        if (mounted)
          setState(() {
            _current = current;
            _currentStatus = _current.status;
          });
      });
    } catch (e) {
      print(e);
    }
  }

  _resumeRecorder() async {
    await _recorder.resume();
    setState(() {});
  }

  _pauseRecorder() async {
    await _recorder.pause();
    setState(() {});
  }

  _stopRecorder() async {
    var result = await _recorder.stop();

    RecorderServices().addRecording(RecorderModel(path: result.path));
    await _instrumentalAudioPlayer.stop();
    await _vocalAudioPlayer.stop();
    setState(() {
      _current = result;
      _currentStatus = _current.status;
      _isRecording = false;
      _isPlaying = false;
    });
    // Toast.show('Song has been saved to recorded list', context, duration: 2);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => Recorded()));
    _init();
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
                text: widget.song.splittedFileName ?? 'Unknown',
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
                    text: currentPlayingTime,
                    textSize: 16,
                    color: AppColor.white,
                    textAlign: TextAlign.center,
                  ),
                  Expanded(
                    child: Slider(
                        activeColor: AppColor.bottomRed,
                        inactiveColor: AppColor.white,
                        value: currentTime.inSeconds.toDouble(),
                        min: 0.0,
                        max: maxTime.inSeconds.toDouble(),
                        onChanged: (double value) {
                          Duration newDuration =
                              Duration(seconds: value.toInt());
                          if (_isPlaying)
                            Future.wait([
                              _instrumentalAudioPlayer.seek(newDuration),
                              _vocalAudioPlayer.seek(newDuration)
                            ]);
                          setState(() {});
                        }),
                  ),
                  TextViewWidget(
                    text: playingCompleteTime,
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                      icon: Icon(
                          _isPlaying
                              ? Icons.pause_circle_outline_rounded
                              : Icons.play_circle_outline_rounded,
                          size: 65,
                          color: AppColor.white),
                      onPressed: () async {
                        if (!_isRecording && _isPlaying) {
                          Future.wait([
                            _instrumentalAudioPlayer.pause(),
                            _vocalAudioPlayer.pause()
                          ]);
                          setState(() {
                            _isPlaying = false;
                          });
                        } else if (_isRecording && _isPlaying) {
                          Future.wait([
                            _instrumentalAudioPlayer.pause(),
                            _vocalAudioPlayer.pause()
                          ]);
                          _pauseRecorder();
                          setState(() {
                            _isPlaying = false;
                          });
                        } else if (_isRecording && !_isPlaying) {
                          Future.wait([
                            _instrumentalAudioPlayer.resume(),
                            _vocalAudioPlayer.resume()
                          ]);
                          _resumeRecorder();
                          setState(() {
                            _isPlaying = true;
                          });
                        } else if (!_isPlaying && !_isRecording) {
                          Future.wait([
                            _instrumentalAudioPlayer.play(widget.song.file,
                                isLocal: true),
                            _vocalAudioPlayer.play(
                                '${widget.song.filePath}/${widget.song.vocalName}',
                                isLocal: true)
                          ]);
                          setState(() {
                            _isPlaying = true;
                          });
                        }
                      }),
                  IconButton(
                      icon: Icon(
                          _playVocals
                              ? Icons.volume_up_outlined
                              : Icons.volume_off_outlined,
                          size: 60,
                          color: AppColor.white),
                      onPressed: () async {
                        _playVocals
                            ? await _vocalAudioPlayer.setVolume(0)
                            : _isRecording
                                ? await _vocalAudioPlayer.setVolume(0.5)
                                : await _vocalAudioPlayer.setVolume(1);
                        setState(() {
                          _playVocals = !_playVocals;
                        });
                      }),
                  Column(
                    children: [
                      Container(
                        width: 80,
                        child: IconButton(
                            icon: Icon(
                              _buildIcon(_currentStatus),
                              size: 60,
                              color: AppColor.white,
                            ),
                            onPressed: () async {
                              if (_isRecording && _isPlaying) _stopRecorder();

                              if (_currentStatus ==
                                      RecordingStatus.Initialized &&
                                  !_isPlaying) {
                                await _instrumentalAudioPlayer
                                    .play(widget.song.file, isLocal: true);
                                await _vocalAudioPlayer.play(
                                  '${widget.song.filePath}/${widget.song.vocalName}',
                                  isLocal: true,
                                );
                                setState(() {
                                  _isPlaying = true;
                                  _isRecording = true;
                                });
                              }

                              if (_currentStatus == RecordingStatus.Paused &&
                                  !_isPlaying) {
                                Future.wait([
                                  _instrumentalAudioPlayer.resume(),
                                  _vocalAudioPlayer.resume()
                                ]);
                                if (_playVocals)
                                  await _vocalAudioPlayer.setVolume(0.5);
                                await _instrumentalAudioPlayer.setVolume(0.5);
                                _resumeRecorder();
                                setState(() {
                                  _isPlaying = true;
                                  _isRecording = true;
                                });
                              }

                              if (_currentStatus ==
                                      RecordingStatus.Initialized &&
                                  _isPlaying) {
                                await _startRecorder();
                                if (_playVocals)
                                  await _vocalAudioPlayer.setVolume(0.5);
                                await _instrumentalAudioPlayer.setVolume(0.5);
                              }
                            }),
                      ),
                      SizedBox(height: 30),
                      Text(
                          _current?.duration.toString().split('.')[0] ??
                              '0:0:00',
                          style: TextStyle(color: AppColor.white)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 70,
            ),
          ],
        ),
      ),
    );
  }
}
