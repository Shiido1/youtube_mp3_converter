import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/database/repository/song_repository.dart';
import 'package:path_provider/path_provider.dart';

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
  List<Song> playLists = [];
  List<Song> favoriteSongs = [];
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

  getPlayLists() async {
    playLists = await SongRepository.getPlayLists();
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
    savePlayingSong(song);
    notifyListeners();
  }

  savePlayingSong(Song song) {
    preferencesHelper.saveValue(
        key: "last_play", value: json.encode(song.toJson()));
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
        if (nextSong == null) return;
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

  List<Map<dynamic, dynamic>> playList = [];

  List<Song> recentList = [];

  Future<String> getPlaylistPath() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    final path = documentDirectory.path + '/playlist.db';
    return path;
  }

  Future<String> getRecentPath() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    final path = documentDirectory.path + '/recent.db';
    return path;
  }

  Future<void> createPlaylist(String name) async {
    var newItem = {
      'name': name,
      'songs': [],
    };
    playList.add(newItem);
    Box db = await Hive.openBox('playlist', path: await getPlaylistPath());
    for (var each in playList) {
      // if it doesnt already exist add it to the database
      if (db.get(each['name']) == null) {
        db.put(each['name'], each);
      }
    }
    refresh();
  }

  Future<void> refresh() async {
    Box db = await Hive.openBox('playlist', path: await getPlaylistPath());
    if (db.values.length != 0) {
      playList.clear();
      for (var each in db.values) {
        // createplaylist should always be first
        if (each['name'] == 'Create playlist') {
          playList.insert(0, each);
          // followed by favourites
        } else if (each['name'] == 'Favourites') {
          playList.insert(1, each);
        } else {
          playList.add(each);
        }
      }
      // await getRecentlyPlayed();
    } else {
      Box recentdb = await Hive.openBox('recent', path: await getRecentPath());
      // else block runs just the first time, when db is empty
      // happens when app is run for the first time or after playlist is reset
      db.put('Create playlist', {'name': 'Create playlist'});
      db.put('Favourites', {
        'name': 'Favourites',
        'songs': [],
      });
      recentdb.put('Recently played', []);
      refresh();
    }
    notifyListeners();
  }

  Future<void> addToPlaylist(String playlistName, Song song) async {
    Box db = await Hive.openBox('playlist', path: await getPlaylistPath());
    var dbPlaylist = db.get(playlistName);
    List songs = dbPlaylist['songs'];
    bool found = songs.any((element) => element['path'] == song.filePath);
    if (!found) {
      songs.add(song.toJson());
      db.put(playlistName, {
        'name': playlistName,
        'songs': songs,
      });
    }
    refresh();
  }
}
