import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/screens/split/database/split_services.dart';

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
  static clear() => _services.clear();
  static removeSongsFromPlaylistAterDelete(String songName) =>
      _services.removeSongsFromPlaylistAterDelete(songName);
  static renameSong({String musicid, String artistName, String songName}) =>
      _services.renameSong(
          musicid: musicid, songName: songName, artistName: artistName);
}

class SplitSongRepository {
  static SplitSongServices _services;
  static bool isHive;

  static init() {
    _services = SplitSongServices();
  }

  static addSong(Song song) => _services.addSong(song);

  static deleteSong(String key) => _services.deleteSong(key);

  static getSongs() => _services.getSongs();
  static renameSong({String fileName, String songName, String artistName}) =>
      _services.renameSong(
          artistName: artistName, songName: songName, fileName: fileName);
  static getDownload(String key) => _services.getDownload(key);
  static addDownload({String key, Song song}) =>
      _services.addDownload(key: key, song: song);
}
