import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'dart:async';
import 'package:file/local.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mp3_music_converter/screens/split/provider/split_song_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:mp3_music_converter/screens/recorded/recorder_services.dart';
import 'package:mp3_music_converter/screens/recorded/model/recorder_model.dart';
import 'package:provider/provider.dart';

class Split extends StatefulWidget {
  final LocalFileSystem localFileSystem;
  final Song song;
  final int width;

  Split({localFileSystem, @required this.song, @required this.width})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();
  @override
  _SplitState createState() => _SplitState();
}

class _SplitState extends State<Split> {
  double val = 0.0;
  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  bool _isRecording = false;
  SplitSongProvider _splitSongProvider;
  Timer _timer;
  BannerAd songAd;

  @override
  void initState() {
    _splitSongProvider = Provider.of(context, listen: false);
    _init();
    showAd(widget.width);
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    if (_splitSongProvider.playerState == PlayerState.PLAYING)
      _splitSongProvider.stopAudio();
    if (_isRecording) _recorder.stop();
    songAd?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  showAd(width) {
    if (songAd == null) {
      BannerAd appAd = BannerAd(
        size: AdSize(height: 70, width: width - 70),
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-4279408488674166/1078290794'
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
        String customPath = 'YTAudioMusicRecords';
        String date =
            "${DateTime.now()?.millisecondsSinceEpoch?.toString()}.wav";
        io.Directory appDocDirectory;
        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }

        io.Directory youtubeRecordDirectory = io.Directory(
            "${appDocDirectory.parent.parent.parent.parent.path}/$customPath");

        if (await youtubeRecordDirectory.exists()) {
          String alphaPath = "${youtubeRecordDirectory.path}/$customPath$date";
          _recorder =
              FlutterAudioRecorder(alphaPath, audioFormat: AudioFormat.WAV);

          await _recorder.initialized;

          print('new status: $_currentStatus');

          var current = await _recorder.current(channel: 0);

          setState(() {
            _current = current;
            _currentStatus = current.status;
          });
        } else {
          youtubeRecordDirectory.create(recursive: true);
          String alphaPath = "${youtubeRecordDirectory.path}/$customPath$date";
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
        _splitSongProvider.updateState(PlayerState.NONE);
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
    print(result.path);
    RecorderServices().addRecording(RecorderModel(path: result.path));
    setState(() {
      _current = result;
      _currentStatus = _current.status;
      _isRecording = false;
    });
    _init();
  }

  IconData _buildIcon(RecordingStatus status) {
    IconData icon;
    switch (_currentStatus) {
      case RecordingStatus.Initialized:
        icon = Icons.mic;
        break;

      case RecordingStatus.Recording:
        icon = Icons.stop;
        break;

      case RecordingStatus.Paused:
        icon = Icons.mic;
        break;

      case RecordingStatus.Stopped:
        icon = Icons.mic_none;
        break;

      default:
        icon = Icons.mic;
        break;
    }
    return icon;
  }

  @override
  Widget build(BuildContext context) {
    print(_currentStatus);
    return Consumer<SplitSongProvider>(builder: (_, _provider, __) {
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
                        image: new AssetImage('assets/new_icon.png'),
                        fit: BoxFit.contain,
                      ),),),
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
                      text: _provider.progress.toString().split(".")[0],
                      textSize: 16,
                      color: AppColor.white,
                      textAlign: TextAlign.center,
                    ),
                    //try and remove the expanded and see
                    Expanded(
                      child: Slider(
                          activeColor: AppColor.bottomRed,
                          inactiveColor: AppColor.white,
                          value: _provider.progress.inSeconds.toDouble(),
                          min: 0.0,
                          max: _provider.totalDuration.inSeconds.toDouble(),
                          onChanged: (double value) {
                            Duration newDuration =
                                Duration(seconds: value.toInt());
                            setState(() {
                              _provider.seekToSecond(
                                  second: newDuration.inSeconds);
                            });
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (!_isRecording)
                      IconButton(
                          icon: Icon(
                              _provider.playerState == PlayerState.PLAYING
                                  ? Icons.pause_circle_outline_rounded
                                  : Icons.play_circle_outline_rounded,
                              size: 65,
                              color: AppColor.white),
                          onPressed: () async {
                            if (_provider.playerState == PlayerState.NONE) {
                              _provider.playAudio(song: widget.song);
                            } else if (_provider.playerState ==
                                PlayerState.PAUSED) {
                              _provider.resumeAudio();
                            } else if (_provider.playerState ==
                                PlayerState.PLAYING) {
                              _provider.pauseAudio();
                            }
                          }),
                    IconButton(
                        icon: Icon(
                          _buildIcon(_currentStatus),
                          size: 65,
                          color: AppColor.white,
                        ),
                        onPressed: () async {
                          switch (_currentStatus) {
                            case RecordingStatus.Initialized:
                              _provider.playAudio(song: widget.song);
                              _start();
                              break;

                            case RecordingStatus.Recording:
                              _provider.stopAudio();
                              _stop();
                              break;

                            case RecordingStatus.Paused:
                              _provider.resumeAudio();
                              _resume();
                              break;

                            case RecordingStatus.Stopped:
                              _init();
                              break;

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
    });
  }
}
