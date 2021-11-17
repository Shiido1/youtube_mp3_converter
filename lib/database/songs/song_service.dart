import 'dart:async';

import 'package:hive/hive.dart';
import 'package:mp3_music_converter/database/hive_boxes.dart';
import '../interface/song_interface.dart';
import '../model/song.dart';

class SongServices implements SongInterface {
  Box<Map> _box;
  Box<List> _boxList;
  StreamController<List<Song>> _conversationsStream =
      StreamController.broadcast();

  Future<Box<Map>> openBox() {
    return PgHiveBoxes.openBox<Map>(PgHiveBoxes.songs);
  }

  _addToStream(List<Song> list) {
    _conversationsStream.add(list
      ..sort((a, b) {
        final _a = a.lastPlayDate ?? DateTime(1999);
        final _b = b.lastPlayDate ?? DateTime(1999);
        return _b.compareTo(_a);
      }));
  }

  @override
  Stream<List<Song>> streamAllSongs() {
    getSongs().then((value) => _addToStream(value));
    return _conversationsStream.stream;
  }

  @override
  addSong(Song song) async {
    if (!(_box?.isOpen ?? false)) _box = await openBox();
    print(song.favorite);
    try {
      _box.put(song.musicid, song.toJson());
      return;
    } catch (e) {
      print(e);
      print(song.fileName);
      return;
    }
  }

  @override
  clear() async {
    if (!(_box?.isOpen ?? false)) _box = await openBox();
    _box.clear();
    return;
  }

  @override
  renameSong({String musicid, String artistName, String songName}) async {
    print(artistName);
    if (!(_box?.isOpen ?? false)) _box = await openBox();
    Song song = Song.fromMap(_box.get(musicid));
    song.artistName = artistName ?? 'Unknown Artist';
    song.songName = songName ?? 'Unknown';
    _box.put(musicid, song.toJson());
  }

  @override
  createPlayList({String playListName, List songs}) async {
    if (!(_boxList?.isOpen ?? false))
      _boxList = await PgHiveBoxes.openBox<List>('playLists');
    if (songs != null && songs.isNotEmpty)
      return addSongsToPlayList(playListName: playListName, songs: songs);
    return _boxList.put(playListName, []);
  }

  @override
  deletePlayList(String key) async {
    if (!(_boxList?.isOpen ?? false))
      _boxList = await PgHiveBoxes.openBox<List>('playLists');
    await _boxList.delete(key);
  }

  @override
  addSongsToPlayList({String playListName, List songs}) async {
    if (!(_boxList?.isOpen ?? false))
      _boxList = await PgHiveBoxes.openBox<List>('playLists');
    if (_boxList.containsKey(playListName)) {
      List playListSongs = _boxList.get(playListName);
      for (String song in songs) {
        if (playListSongs.contains(song)) playListSongs.remove(song);
      }
      playListSongs.addAll(songs);
      return _boxList.put(playListName, playListSongs);
    }
    if (_boxList.containsKey(playListName) == false)
      return _boxList.put(playListName, songs);
  }

  @override
  removeSongFromPlayList({String playListName, List songs}) async {
    if (!(_boxList?.isOpen ?? false))
      _boxList = await PgHiveBoxes.openBox<List>('playLists');
    List playListSongs = _boxList.get(playListName);
    for (String song in songs) {
      playListSongs.remove(song);
    }
    _boxList.put(playListName, playListSongs);
  }

  @override
  renamePlayList({String oldName, String newName}) async {
    if (!(_boxList?.isOpen ?? false))
      _boxList = await PgHiveBoxes.openBox<List>('playLists');
    List playListSongs = _boxList.get(oldName);
    deletePlayList(oldName);
    addSongsToPlayList(playListName: newName, songs: playListSongs);
  }

  @override
  Future<List<Song>> getSongs() async {
    if (!(_box?.isOpen ?? false)) _box = await openBox();
    return _box.values.map((e) => e).map((e) => Song.fromMap(e)).toList();
  }

  @override
  Future<List> getPlayListsSongs(key) async {
    if (!(_boxList?.isOpen ?? false))
      _boxList = await PgHiveBoxes.openBox<List>('playLists');

    return _boxList.get(key);
  }

  @override
  Future<List> getPlayListNames() async {
    if (!(_boxList?.isOpen ?? false))
      _boxList = await PgHiveBoxes.openBox<List>('playLists');
    return _boxList.keys.toList();
  }

  @override
  Future<List<Song>> getFavoriteSongs() async {
    if (!(_box?.isOpen ?? false)) _box = await openBox();
    return _box.values
        .where((e) => e['favorite'] == true)
        .map((e) => Song.fromMap(e))
        .toList();
  }

  @override
  Stream<BoxEvent> watchSongs() => _box.watch();

  @override
  deleteSong(String musicid) async {
    if (!(_box?.isOpen ?? false)) _box = await openBox();
    await _box.delete(musicid);
  }

  removeSongsFromPlaylistAterDelete(String musicid) async {
    if (!(_boxList?.isOpen ?? false))
      _boxList = await PgHiveBoxes.openBox<List>('playLists');
    List playlist = [];
    _boxList.keys.forEach((element) {
      if (_boxList.get(element).contains(musicid)) playlist.add(element);
    });
    if (playlist.isNotEmpty) {
      playlist.forEach((element) async {
        List songs = _boxList.get(element);
        songs.remove(musicid);
        await _boxList.put(element, songs);
      });
    }
  }
}
