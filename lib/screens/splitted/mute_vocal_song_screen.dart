import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'dart:async';
import 'package:file/local.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mp3_music_converter/screens/recorded/model/recorder_model.dart';
import 'package:mp3_music_converter/screens/recorded/recorded.dart';
import 'package:mp3_music_converter/screens/recorded/recorder_services.dart';
import 'package:mp3_music_converter/screens/splitted/provider/splitted_song_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:audio_session/audio_session.dart' as asp;
import 'package:provider/provider.dart';

class MuteVocalsScreen extends StatefulWidget {
  final LocalFileSystem localFileSystem;
  final Song song;
  final int width;

  MuteVocalsScreen({localFileSystem, @required this.song, @required this.width})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  _MuteVocalsScreenState createState() => _MuteVocalsScreenState();
}

class _MuteVocalsScreenState extends State<MuteVocalsScreen> {
  bool _isRecording = false;
  bool _playVocals = true;
  asp.AudioSession audioSession;
  SplittedSongProvider _songProvider;
  Timer _timer;
  BannerAd songAd;

  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;

  @override
  void initState() {
    _songProvider = Provider.of<SplittedSongProvider>(context, listen: false);
    _init();
    showAd(widget.width);
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    if (_songProvider.playerState != PlayerState.NONE)
      _songProvider.stopAudio();
    if (_isRecording) _recorder.stop();
    _timer?.cancel();
    songAd?.dispose();
    super.dispose();
  }

  showAd(width) {
    if (songAd == null) {
      BannerAd appAd = BannerAd(
        size: AdSize(height: 70, width: width - 70),
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-4279408488674166/9228377666'
            : 'ca-app-pub-4279408488674166/6018640831',
        listener: BannerAdListener(
          onAdFailedToLoad: (ad, error) => ad.dispose(),
          onAdLoaded: (ad) => setState(() {
            songAd = ad;
          }),
        ),
        request: AdRequest(),
      );
      appAd.load();
    }
  }

  void startTimer() async {
    const time = const Duration(seconds: 10);
    _timer = new Timer.periodic(time, (timer) async {
      showAd(widget.width);
    });
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

  Future<void> _startRecorder() async {
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

  Future<void> _stopRecorder() async {
    var result = await _recorder.stop();

    RecorderServices().addRecording(RecorderModel(path: result.path));
    _songProvider.stopAudio();
    setState(() {
      _current = result;
      _currentStatus = _current.status;
      _isRecording = false;
    });
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
    return Consumer<SplittedSongProvider>(builder: (_, _provider, __) {
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
                  text: widget.song.songName ?? 'Unknown Song',
                  color: AppColor.white,
                  textSize: 15,
                  fontFamily: 'Roboto-Regular',
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: TextViewWidget(
                  text: widget.song.artistName ?? 'Unknown Artist',
                  color: AppColor.white,
                  textSize: 13,
                  fontFamily: 'Roboto-Regular',
                ),
              ),
              SizedBox(height: 30),
              if (songAd != null)
                Container(
                    child: AdWidget(ad: songAd),
                    alignment: Alignment.center,
                    height: songAd.size.height.toDouble(),
                    width: songAd.size.width.toDouble()),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 300,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    TextViewWidget(
                      text: _provider.progress.toString().split('.')[0],
                      textSize: 16,
                      color: AppColor.white,
                      textAlign: TextAlign.center,
                    ),
                    Expanded(
                      child: Slider(
                          activeColor: AppColor.bottomRed,
                          inactiveColor: AppColor.white,
                          value: _provider.progress.inSeconds.toDouble(),
                          min: 0.0,
                          max: _provider.totalDuration.inSeconds.toDouble(),
                          onChanged: (double value) async {
                            Duration newDuration =
                                Duration(seconds: value.toInt());
                            if (_provider.playerState == PlayerState.PLAYING ||
                                _provider.playerState == PlayerState.PAUSED)
                              await Future.wait([
                                _provider.seekToSecond(
                                    second: newDuration.inSeconds,
                                    playVocals: true),
                              ]);
                            setState(() {});
                          }),
                    ),
                    TextViewWidget(
                      text: _provider.totalDuration.toString().split('.')[0],
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
                    if (!_isRecording)
                      IconButton(
                          icon: Icon(
                              _provider.playerState == PlayerState.PLAYING &&
                                      !_isRecording
                                  ? Icons.pause_circle_outline_rounded
                                  : Icons.play_circle_outline_rounded,
                              size: 65,
                              color: AppColor.white),
                          onPressed: () async {
                            if (!_isRecording &&
                                _provider.playerState == PlayerState.PLAYING) {
                              await Future.wait([
                                _provider.pauseAudio(),
                              ]);
                            } else if (_provider.playerState ==
                                    PlayerState.NONE &&
                                !_isRecording) {
                              await Future.wait([
                                _provider.playAudio(
                                    song: widget.song,
                                    file:
                                        '${widget.song.filePath}/${widget.song.vocalName}',
                                    playVocals: true),
                              ]);
                            } else if (_provider.playerState ==
                                    PlayerState.PAUSED &&
                                !_isRecording) {
                              await Future.wait([
                                _provider.resumeAudio(),
                              ]);
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
                              ? await _provider.setVocalVolume(0)
                              : _isRecording
                                  ? await _provider.setVocalVolume(0.5)
                                  : await _provider.setVocalVolume(1);
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
                                if (_currentStatus ==
                                        RecordingStatus.Initialized &&
                                    _provider.playerState == PlayerState.NONE) {
                                  await Future.wait([
                                    _provider.playAudio(
                                        song: widget.song,
                                        file:
                                            '${widget.song.filePath}/${widget.song.vocalName}',
                                        playVocals: true),
                                    _startRecorder()
                                  ]);

                                  setState(() {
                                    _isRecording = true;
                                  });
                                } else if (_currentStatus ==
                                        RecordingStatus.Initialized &&
                                    _provider.playerState ==
                                        PlayerState.PLAYING) {
                                  await _startRecorder();
                                  if (_playVocals)
                                    await _provider.setVocalVolume(0.5);
                                  await _provider.setVolume(0.5);
                                } else
                                  await _stopRecorder();
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
    });
  }
}
