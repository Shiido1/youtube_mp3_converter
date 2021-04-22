import 'package:flutter/material.dart';
import 'package:mp3_music_converter/database/model/song.dart';

abstract class SongInterface {
  addSong(Song log);
  createPlayList({@required String playListName, List songs});
  addSongsToPlayList({@required String playListName, @required List songs});
  removeSongFromPlayList({@required String playListName, @required List songs});
  Future<List<Song>> getSongs();
  Future<List> getPlayListsSongs(key);
  Future<List> getPlayListNames();
  Future<List<Song>> getFavoriteSongs();
  renamePlayList({String oldName, String newName});
  deletePlayList(String key);
  deleteSong(String key);
  watchSongs();
  Stream<List<Song>> streamAllSongs();
}

abstract class SplittedSongInterface {
  addSong(Song log);
  Future<List<Song>> getSongs();
  deleteSong(String key);
}
