import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/database/repository/song_repository.dart';
import 'package:mp3_music_converter/screens/song/provider/music_provider.dart';

enum PlayerType { ALL, SHUFFLE, REPEAT }

enum PlayerState { NONE, PLAYING, PAUSED }

class SplittedSongProvider with ChangeNotifier {
  Duration totalDuration = Duration();
  Duration progress = Duration();
  Song currentSong;
  List<Song> songs = [];
  List<Song> allSongs = [];
  List splittedSongName = [];
  List splittedSongItems = [];
  List emptyNames = [];
  List noVocals = [];
  bool shuffleSong = false;
  bool repeatSong = false;
  int _currentSongIndex = -1;
  int get length => songs.length;
  int get songNumber => _currentSongIndex + 1;

  AudioPlayerState audioPlayerState;
  PlayerType playerType = PlayerType.ALL;
  PlayerState playerState = PlayerState.NONE;

  initProvider() {
    SplittedSongRepository.init();
    initPlayer();
  }

  getSongs(bool showAll) async {
    allSongs = await SplittedSongRepository.getSongs();
    for (Song song in allSongs) print(song.vocalName);
    for (Song song in allSongs)
      if (song.fileName == '' || song.fileName == null) emptyNames.add(song);
    if (emptyNames.isNotEmpty)
      for (Song song in emptyNames) allSongs.remove(song);

    if (!showAll) {
      for (Song song in allSongs)
        if (song.vocalName == '' || song.vocalName == null) noVocals.add(song);
      if (noVocals.isNotEmpty)
        for (Song song in noVocals) allSongs.remove(song);
    }

    notifyListeners();
  }

  void initPlayer() {
    AudioService.customEventStream.listen((event) {
      if (event[AudioPlayerTask.DURATION] != null &&
          event['identity'] == 'split') {
        totalDuration =
            Duration(seconds: event[AudioPlayerTask.DURATION]) ?? Duration();
        notifyListeners();
      }
      if (event[AudioPlayerTask.POSITION] != null &&
          event['identity'] == 'split') {
        progress =
            Duration(seconds: event[AudioPlayerTask.POSITION]) ?? Duration();
        notifyListeners();
      }
      if (event[AudioPlayerTask.STATE] != null &&
          event['identity'] == 'split') {
        audioPlayerState = event[AudioPlayerTask.STATE];
        switch (audioPlayerState) {
          case AudioPlayerState.STOPPED:
            playerState = PlayerState.NONE;
            break;
          case AudioPlayerState.PLAYING:
            playerState = PlayerState.PLAYING;
            break;
          case AudioPlayerState.PAUSED:
            playerState = PlayerState.PAUSED;
            break;
          case AudioPlayerState.COMPLETED:
            playerState = PlayerState.NONE;
            break;
        }
        notifyListeners();
      }
    });
  }

  void updateState(PlayerState state) {
    this.playerState = state;
    notifyListeners();
  }

  void updateLocal(Song song) {
    if (audioPlayerState != AudioPlayerState.PLAYING) {
      currentSong = songs.firstWhere(
          (element) => element.fileName == song.fileName,
          orElse: () => song);
      notifyListeners();
    }
  }

  Future<void> seekToSecond(
      {@required int second, bool playVocals = false}) async {
    await AudioService.customAction(AudioPlayerTask.SEEK_TO, second);
  }

  Future<void> playAudio(
      {@required Song song, String file, bool playVocals = false}) async {
    playerState = PlayerState.PLAYING;
    await AudioService.customAction(AudioPlayerTask.PLAY, {
      'url': song.file,
      'identity': 'split',
      'path': file ?? '',
      'playVocals': playVocals
    });
    notifyListeners();
  }

  Future<void> resumeAudio() async {
    playerState = PlayerState.PLAYING;
    await AudioService.customAction(AudioPlayerTask.RESUME);
    notifyListeners();
  }

  Future<void> pauseAudio() async {
    playerState = PlayerState.PAUSED;
    await AudioService.customAction(AudioPlayerTask.PAUSE);
    notifyListeners();
  }

  Future<void> stopAudio() async {
    playerState = PlayerState.NONE;
    await AudioService.customAction(AudioPlayerTask.STOP);
    progress = Duration();
    notifyListeners();
  }

  Future<void> setVolume(double vol) async {
    await AudioService.customAction(AudioPlayerTask.VOLUME, vol);
    notifyListeners();
  }

  Future<void> setVocalVolume(double vol) async {
    await AudioService.customAction(AudioPlayerTask.VOCAL_VOLUME, vol);
    notifyListeners();
  }
}
