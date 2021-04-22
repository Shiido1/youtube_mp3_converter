import 'dart:async';

import 'package:hive/hive.dart';
import 'package:mp3_music_converter/database/hive_boxes.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/database/interface/song_interface.dart';

class SplittedSongServices implements SplittedSongInterface {
  Box<Map> _box;

  Future<Box<Map>> openBox() {
    return SplitHiveBoxes.openBox<Map>(SplitHiveBoxes.songs);
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
  deleteSong(String key) async {
    if (!(_box?.isOpen ?? false)) _box = await openBox();
    await _box.delete(key);
  }
}
