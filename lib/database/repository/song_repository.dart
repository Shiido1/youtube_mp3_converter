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
  static removeSongsFromPlaylistAterDelete(String songName) =>
      _services.removeSongsFromPlaylistAterDelete(songName);
}

class SplittedSongRepository {
  static SplittedSongServices _services;
  static bool isHive;

  static init() {
    _services = SplittedSongServices();
  }

  static addSong(Song song) => _services.addSong(song);

  static deleteSong(String key) => _services.deleteSong(key);

  static getSongs() => _services.getSongs();
}
