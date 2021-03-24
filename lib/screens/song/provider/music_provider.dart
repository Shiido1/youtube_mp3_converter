import 'dart:math';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/database/repository/song_repository.dart';

enum PlayerType {ALL, SHUFFLE, REPEAT}

class MusicProvider with ChangeNotifier {
  Duration totalDuration = Duration();
  Duration progress = Duration();
  AudioPlayer advancedPlayer;
  AudioCache audioCache;
  Song currentSong;
  Song drawerItem;
  List<Song> songs = [];
  List<Song> allSongs = [];
  List<Song> playLists = [];
  List<Song> favoriteSongs = [];
  int _currentSongIndex = -1;
  int get length => songs.length;
  int get songNumber => _currentSongIndex + 1;

  AudioPlayerState audioPlayerState;
  PlayerControlCommand playerControlCommand;
  PlayerType playerType = PlayerType.ALL;

  initProvider(){
    SongRepository.init();
    initPlayer();
  }
  
  getSongs()async{
    allSongs = await SongRepository.getSongs();
    notifyListeners();
  }

  getPlayLists()async{
    playLists = await SongRepository.getPlayLists();
    notifyListeners();
  }

  getFavoriteSongs()async{
    favoriteSongs = await SongRepository.getFavoriteSongs();
    notifyListeners();
  }

  updateSong(Song song){
    songs.forEach((element) {
      if(element.fileName == song.fileName){
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

  void updateLocal(Song log) {
    currentSong = log;
    notifyListeners();
  }

  void updateDrawer(Song log) {
    drawerItem = log;
    notifyListeners();
  }

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    advancedPlayer.seek(newDuration);
  }

  void playAudio(Song song,) async {
    if(audioPlayerState == AudioPlayerState.PLAYING && currentSong.fileName == song.fileName) return;
    if (advancedPlayer == null) initPlayer();
    if (audioPlayerState == AudioPlayerState.PLAYING) stopAudio();
    await advancedPlayer.play(song.file);
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
    progress = Duration();
    notifyListeners();
  }

  void completion() async {
    audioPlayerState = AudioPlayerState.STOPPED;
    switch(playerType){
      case PlayerType.ALL:
        playAudio(nextSong);
        break;
      case PlayerType.SHUFFLE:
        shuffle();
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

  Future shuffle() async {
    playerType = PlayerType.SHUFFLE;
    playAudio(randomSong);
    notifyListeners();
  }

  Future repeat(Song song) async {
    playerType = PlayerType.REPEAT;
    playAudio(song);
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
    return songs[r.nextInt(songs.length)];
  }

  Song get prevSong {
    if (_currentSongIndex > 0) {
      _currentSongIndex--;
    }
    if (_currentSongIndex < 0) return null;
    return songs[_currentSongIndex];
  }
}
