import 'dart:convert';
import 'dart:math';
import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/screens/recorded/recorder_services.dart';
import 'package:mp3_music_converter/screens/recorded/model/recorder_model.dart';
import 'package:audio_session/audio_session.dart' as asp;
import 'package:mp3_music_converter/screens/song/provider/music_provider.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';

enum PlayerType { ALL, SHUFFLE, REPEAT }

class RecordProvider with ChangeNotifier {
  Duration totalDuration = Duration();
  Duration progress = Duration();
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
  asp.AudioSession audioSession;

  initProvider() {
    initPlayer();
  }

  getRecords() async {
    allRecords = await RecorderServices().getRecordings();
    notifyListeners();
  }

  updateRecord(RecorderModel recorded) {
    if (audioPlayerState != AudioPlayerState.PLAYING &&
        audioPlayerState != AudioPlayerState.PAUSED)
      currentRecord = records.firstWhere(
          (element) => element.name == recorded.name,
          orElse: () => recorded);

    notifyListeners();
  }

  void initPlayer() {
    AudioService.customEventStream.listen((event) {
      if (event[AudioPlayerTask.DURATION] != null &&
          event['identity'] == 'recorder') {
        totalDuration =
            Duration(seconds: event[AudioPlayerTask.DURATION]) ?? Duration();
        notifyListeners();
      }
      if (event[AudioPlayerTask.POSITION] != null &&
          event['identity'] == 'recorder') {
        progress =
            Duration(seconds: event[AudioPlayerTask.POSITION]) ?? Duration();
        notifyListeners();
      }
      if (event[AudioPlayerTask.STATE] != null &&
          event['identity'] == 'recorder') {
        audioPlayerState = event[AudioPlayerTask.STATE];
        notifyListeners();
      }
      if (event[AudioPlayerTask.COMPLETION] != null &&
          event['identity'] == 'recorder') {
        completion();
      }
    });
  }

  void seekToSecond(int second) {
    AudioService.customAction(AudioPlayerTask.SEEK_TO, second);
  }

  void playAudio(
    RecorderModel record,
  ) async {
    if (audioPlayerState == AudioPlayerState.PLAYING &&
        currentRecord.name == record.name) return;
    currentRecord = record;
    savePlayingSong({'name': record.name, 'path': record.path});
    AudioService.customAction(
        AudioPlayerTask.PLAY, {'url': record.path, 'identity': 'recorder'});
  }

  savePlayingSong(Map song) {
    preferencesHelper.saveValue(
        key: 'last_play_record', value: json.encode(song));
  }

  void resumeAudio() async {
    await AudioService.customAction(AudioPlayerTask.RESUME);
    notifyListeners();
  }

  void pauseAudio() async {
    await AudioService.customAction(AudioPlayerTask.PAUSE);
    notifyListeners();
  }

  void stopAudio() async {
    await AudioService.customAction(AudioPlayerTask.STOP);
    progress = Duration();
    notifyListeners();
  }

  void completion() async {
    switch (playerType) {
      case PlayerType.ALL:
        if (!canNextRecord) playAudio(nextRecord);
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
        playAudio(currentRecord);
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
