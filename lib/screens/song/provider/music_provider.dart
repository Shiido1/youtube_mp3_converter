import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/database/model/log.dart';

class MusicProvider with ChangeNotifier {
  Duration totalDuration = new Duration();
  Duration progress = new Duration();
  AudioPlayer advancedPlayer;
  AudioCache audioCache;
  Log musicdata;
  Log drawerItem;

  String mp3;
  AudioPlayerState audioPlayerState;

  void initPlayer() {
    if (advancedPlayer != null) return;
    advancedPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: advancedPlayer);
    advancedPlayer.onAudioPositionChanged.listen((Duration position) {
      progress = position;
      notifyListeners();
    });

    advancedPlayer.onDurationChanged.listen((Duration duration) {
      totalDuration = duration;
      ;
      notifyListeners();
    });
    advancedPlayer.onPlayerStateChanged.listen((AudioPlayerState s) {
      audioPlayerState = s;
      notifyListeners();
    });
  }

  void updateLocal(Log log) {
    musicdata = log;
    notifyListeners();
  }

  void updateDrawer(Log log) {
    drawerItem = log;
    notifyListeners();
  }

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);

    advancedPlayer.seek(newDuration);
  }

  void playAudio(mp3) async {
    if (advancedPlayer == null) initPlayer();
    if (audioPlayerState == AudioPlayerState.PLAYING) stopAudio();

    await advancedPlayer.play(mp3);
    notifyListeners();
  }

  void resumeAudio() async {
    await advancedPlayer.resume();
    notifyListeners();
  }

  void pauseAudio() async {
    await advancedPlayer.pause();
    notifyListeners();
  }

  void stopAudio() async {
    await advancedPlayer.stop();
    notifyListeners();
  }

  handlePlaying(mp3, {AudioPlayerState state}) {
    if (state != null) audioPlayerState = state;
    switch (audioPlayerState) {
      case AudioPlayerState.STOPPED:
        stopAudio();
        break;
      case AudioPlayerState.PAUSED:
        resumeAudio();
        break;
      case AudioPlayerState.PLAYING:
        pauseAudio();
        break;
      case AudioPlayerState.COMPLETED:
        playAudio(mp3);
        break;
      default:
        playAudio(mp3);
    }
  }
}
