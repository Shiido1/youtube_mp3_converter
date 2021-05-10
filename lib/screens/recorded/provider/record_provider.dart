import 'dart:math';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/screens/recorded/recorder_services.dart';
import 'package:mp3_music_converter/screens/recorded/model/recorder_model.dart';

enum PlayerType { ALL, SHUFFLE, REPEAT }

class RecordProvider with ChangeNotifier {
  Duration totalDuration = Duration();
  Duration progress = Duration();
  AudioPlayer recordPlayer;
  AudioCache audioCache;
  RecorderModel currentRecord;
  List<RecorderModel> records = [];
  List<RecorderModel> allRecords = [];
  bool shuffleRecord = false;
  bool repeatRecord = false;
  int _currentRecordIndex = -1;
  int get length => records.length;
  int get songNumber => _currentRecordIndex + 1;

  AudioPlayerState audioPlayerState;
  PlayerControlCommand playerControlCommand;
  PlayerType playerType = PlayerType.ALL;

  initProvider() {
    initPlayer();
  }

  getRecords() async {
    allRecords = await RecorderServices().getRecordings();
    notifyListeners();
  }

  updateRecord(RecorderModel recorded) {
    records.forEach((element) {
      if (element.name == recorded.name) {
        element = recorded;
      }
    });
    notifyListeners();
  }

  void initPlayer() {
    if (recordPlayer != null) return;
    recordPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: recordPlayer);
    recordPlayer.onAudioPositionChanged.listen((Duration position) {
      progress = position;
      notifyListeners();
    });

    recordPlayer.onDurationChanged.listen((Duration duration) {
      totalDuration = duration;
      notifyListeners();
    });
    recordPlayer.onPlayerStateChanged.listen((AudioPlayerState s) {
      audioPlayerState = s;
      notifyListeners();
    });

    recordPlayer.onPlayerCompletion.listen((event) {
      completion();
    });
  }

  void updateLocal(RecorderModel record) {
    if (audioPlayerState != AudioPlayerState.PLAYING) {
      currentRecord = records.firstWhere(
          (element) => element.name == record.name,
          orElse: () => record);
      notifyListeners();
    }
  }

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    recordPlayer.seek(newDuration);
  }

  void playAudio(
    RecorderModel record,
  ) async {
    if (audioPlayerState == AudioPlayerState.PLAYING &&
        currentRecord.name == record.name) return;
    if (recordPlayer == null) initPlayer();
    if (audioPlayerState == AudioPlayerState.PLAYING) stopAudio();
    await recordPlayer.play(record.path);
    currentRecord = record;
    notifyListeners();
  }

  void resumeAudio() async {
    await recordPlayer.resume();
    notifyListeners();
  }

  void pauseAudio() async {
    await recordPlayer.pause();
    notifyListeners();
  }

  void stopAudio() async {
    await recordPlayer.stop();
    progress = Duration();
    notifyListeners();
  }

  void completion() async {
    audioPlayerState = AudioPlayerState.STOPPED;
    switch (playerType) {
      case PlayerType.ALL:
        playAudio(nextRecord);
        break;
      case PlayerType.SHUFFLE:
        shuffle(false);
        break;
      case PlayerType.REPEAT:
        playAudio(currentRecord);
        break;
    }
    notifyListeners();
  }

  Future next() async {
    playAudio(nextRecord);
    notifyListeners();
  }

  Future prev() async {
    playAudio(prevRecord);
    notifyListeners();
  }

  Future shuffle(bool force) async {
    shuffleRecord = true;
    playerType = PlayerType.SHUFFLE;
    if (force) playAudio(randomRecord);
    if (audioPlayerState == AudioPlayerState.STOPPED) playAudio(randomRecord);
    notifyListeners();
  }

  Future stopShuffle() async {
    shuffleRecord = false;
    playerType = PlayerType.ALL;
    notifyListeners();
  }

  Future repeat(RecorderModel record) async {
    playerType = PlayerType.REPEAT;
    repeatRecord = true;
    playAudio(record);
    notifyListeners();
  }

  Future undoRepeat() async {
    repeatRecord = false;
    playerType = PlayerType.ALL;
    notifyListeners();
  }

  handlePlaying() {
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
        playAudio(currentRecord);
        break;
      default:
        playAudio(currentRecord);
    }
  }

  setCurrentIndex(int index) {
    _currentRecordIndex = index;
  }

  int get currentIndex => _currentRecordIndex;

  bool get canNextRecord => _currentRecordIndex == length - 1;
  bool get canPrevRecord => _currentRecordIndex == 0;

  RecorderModel get nextRecord {
    if (_currentRecordIndex < length) {
      _currentRecordIndex++;
    }
    if (_currentRecordIndex >= length) return null;
    return records[_currentRecordIndex];
  }

  RecorderModel get randomRecord {
    Random r = new Random();
    int recordIndex = r.nextInt(records.length);
    setCurrentIndex(recordIndex);
    return records[recordIndex];
  }

  RecorderModel get prevRecord {
    if (_currentRecordIndex > 0) {
      _currentRecordIndex--;
    }
    if (_currentRecordIndex < 0) return null;
    return records[_currentRecordIndex];
  }
}
