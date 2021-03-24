import 'package:mp3_music_converter/database/model/song.dart';

abstract class SongInterface {
  addSong(Song log);
  Future<List<Song>> getSongs();
  Future<List<Song>> getPlayLists();
  Future<List<Song>> getFavoriteSongs();
  deleteSong(String key);
  watchSongs();
  Stream<List<Song>> streamAllSongs();
}
