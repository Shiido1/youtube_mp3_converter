import 'dart:async';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:mp3_music_converter/database/hive_boxes.dart';
import 'package:path_provider/path_provider.dart';

import '../interface/song_interface.dart';
import '../model/song.dart';

class SongServices implements SongInterface {
  Box<Map> _box;
  StreamController<List<Song>> _conversationsStream = StreamController.broadcast();


  Future<Box<Map>> openBox() {
    return PgHiveBoxes.openBox<Map>(PgHiveBoxes.songs);
  }

  _addToStream(List<Song> list) {
    _conversationsStream.add(list..sort((a, b) {
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
    return _box.put(song.fileName, song.toJson());
  }

  @override
  Future<List<Song>> getSongs() async {
    if (!(_box?.isOpen ?? false)) _box = await openBox();
    return _box.values.map((e) => e).map((e) => Song.fromMap(e)).toList();
  }

  @override
  Future<List<Song>> getPlayLists() async {
    if (!(_box?.isOpen ?? false)) _box = await openBox();
    return _box.values.where((e) => e['playList'] == true).map((e) => Song.fromMap(e)).toList();
  }

  @override
  Future<List<Song>> getFavoriteSongs() async {
    if (!(_box?.isOpen ?? false)) _box = await openBox();
    return _box.values.where((e) => e['favorite'] == true).map((e) => Song.fromMap(e)).toList();
  }

  @override
  Stream<BoxEvent> watchSongs() => _box.watch();

  @override
  deleteSong(String key) async {
    if (!(_box?.isOpen ?? false)) _box = await openBox();
    await _box.delete(key);
  }

}
