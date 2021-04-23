import 'dart:convert';
import 'dart:math';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/database/repository/song_repository.dart';

import '../../../utils/helper/instances.dart';

enum PlayerType { ALL, SHUFFLE, REPEAT }

class MusicProvider with ChangeNotifier {
  Duration totalDuration = Duration();
  Duration progress = Duration();
  AudioPlayer advancedPlayer;
  AudioCache audioCache;
  Song currentSong;
  Song drawerItem;
  List<Song> songs = [];
  List<Song> allSongs = [];
  List playLists = [];
  List playListSongTitle = [];
  List<Song> favoriteSongs = [];
  bool shuffleSong = false;
  bool repeatSong = false;
  int _currentSongIndex = -1;
  int get length => songs.length;
  int get songNumber => _currentSongIndex + 1;

  AudioPlayerState audioPlayerState;
  PlayerControlCommand playerControlCommand;
  PlayerType playerType = PlayerType.ALL;

  initProvider() {
    SongRepository.init();
    initPlayer();
  }

  getSongs() async {
    allSongs = await SongRepository.getSongs();
    notifyListeners();
  }

  getPlayListNames() async {
    playLists = await SongRepository.getPlayListNames();
    notifyListeners();
  }

  getPlayListSongTitle(key) async {
    playListSongTitle = await SongRepository.getPlayListsSongs(key);
    notifyListeners();
  }

  getFavoriteSongs() async {
    favoriteSongs = await SongRepository.getFavoriteSongs();
    notifyListeners();
  }

  updateSong(Song song) {
    songs.forEach((element) {
      if (element.fileName == song.fileName) {
        element = song;
      }
    });
    SongRepository.addSong(song);
    notifyListeners();
  }

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
      notifyListeners();
    });
    advancedPlayer.onPlayerStateChanged.listen((AudioPlayerState s) {
      audioPlayerState = s;
      notifyListeners();
    });

    advancedPlayer.onPlayerCompletion.listen((event) {
      completion();
    });
  }

  void updateLocal(Song song) {
    if (audioPlayerState != AudioPlayerState.PLAYING) {
      currentSong = songs.firstWhere(
          (element) => element.fileName == song.fileName,
          orElse: () => song);
      notifyListeners();
    }
  }

  void updateDrawer(Song log) {
    drawerItem = log;
  }

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    advancedPlayer.seek(newDuration);
  }

  void playAudio(
    Song song,
  ) async {
    if (audioPlayerState == AudioPlayerState.PLAYING &&
        currentSong.fileName == song.fileName) return;
    if (advancedPlayer == null) initPlayer();
    if (audioPlayerState == AudioPlayerState.PLAYING) stopAudio();
    await advancedPlayer.play(song.file);
    currentSong = song;
    // savePlayingSong(song);
    notifyListeners();
  }

  savePlayingSong(Song song) {
    preferencesHelper.saveValue(
        key: 'last_play', value: json.encode(song.toJson()));
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
    progress = Duration();
    notifyListeners();
  }

  void completion() async {
    audioPlayerState = AudioPlayerState.STOPPED;
    switch (playerType) {
      case PlayerType.ALL:
        playAudio(nextSong);
        break;
      case PlayerType.SHUFFLE:
        shuffle(false);
        break;
      case PlayerType.REPEAT:
        playAudio(currentSong);
        break;
    }
    notifyListeners();
  }

  Future next() async {
    playAudio(nextSong);
    notifyListeners();
  }

  Future prev() async {
    playAudio(prevSong);
    notifyListeners();
  }

  Future shuffle(bool force) async {
    shuffleSong = true;
    playerType = PlayerType.SHUFFLE;
    if (force) playAudio(randomSong);
    if (audioPlayerState == AudioPlayerState.STOPPED) playAudio(randomSong);
    notifyListeners();
  }

  Future stopShuffle() async {
    shuffleSong = false;
    playerType = PlayerType.ALL;
    notifyListeners();
  }

  Future repeat(Song song) async {
    playerType = PlayerType.REPEAT;
    repeatSong = true;
    playAudio(song);
    notifyListeners();
  }

  Future undoRepeat () async {
    repeatSong = false;
    playerType = PlayerType.ALL;
    notifyListeners();
  }

  // Future repeatAll() async {
  //   playerType = PlayerType.ALL;
  //   if (nextSong == null) {
  //     setCurrentIndex(0);
  //     playAudio(songs[0]);
  //   }
  //   notifyListeners();
  // }

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
        playAudio(currentSong);
        break;
      default:
        playAudio(currentSong);
    }
  }

  setCurrentIndex(int index) {
    _currentSongIndex = index;
  }

  int get currentIndex => _currentSongIndex;

  bool get canNextSong => _currentSongIndex == length - 1;
  bool get canPrevSong => _currentSongIndex == 0;

  Song get nextSong {
    if (_currentSongIndex < length) {
      _currentSongIndex++;
    }
    if (_currentSongIndex >= length) return null;
    return songs[_currentSongIndex];
  }

  Song get randomSong {
    Random r = new Random();
    int songIndex = r.nextInt(songs.length);
    setCurrentIndex(songIndex);
    return songs[songIndex];
  }

  Song get prevSong {
    if (_currentSongIndex > 0) {
      _currentSongIndex--;
    }
    if (_currentSongIndex < 0) return null;
    return songs[_currentSongIndex];
  }
}
