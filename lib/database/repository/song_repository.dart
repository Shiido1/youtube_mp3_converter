import 'package:hive/hive.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/screens/splitted/database/split_services.dart';

import '../songs/song_service.dart';

class SongRepository {
  static SongServices _services;
  static bool isHive;

  static init() {
    _services = SongServices();
  }

  static addSong(Song song) => _services.addSong(song);
  static addSongsToPlayList(playListName, songs) =>
      _services.addSongsToPlayList(playListName: playListName, songs: songs);
  static createPlayList(playListName, songs) =>
      _services.createPlayList(playListName: playListName, songs: songs);
  static deletePlayList(String key) => _services.deletePlayList(key);
  static renamePlayList({String oldName, String newName}) =>
      _services.renamePlayList(oldName: oldName, newName: newName);
  static removeSongFromPlayList({String playListName, List songs}) => _services
      .removeSongFromPlayList(songs: songs, playListName: playListName);
  static deleteSong(String key) => _services.deleteSong(key);
  static getSongs() => _services.getSongs();
  static getPlayListsSongs(key) => _services.getPlayListsSongs(key);
  static getPlayListNames() => _services.getPlayListNames();
  static getFavoriteSongs() => _services.getFavoriteSongs();
  static Stream<List<Song>> streamAllSongs() => _services.streamAllSongs();
}

class SplittedSongRepository {
  static SplittedSongServices _services;
  static bool isHive;

  static init() {
    _services = SplittedSongServices();
  }

  static addSong({String songName, List<Song> splittedSongs}) async {
    await _services.addSong(songName: songName, splittedSongs: splittedSongs);
  }

  static deleteSong(String key) async {
    await _services.deleteSong(key);
  }

  static getSplit(String key) async {
    await _services.getSplit(key);
  }

  static getSplittedSongName() async {
    await _services.getSplittedSongName();
  }
}
