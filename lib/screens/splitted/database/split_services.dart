import 'dart:async';

import 'package:hive/hive.dart';
import 'package:mp3_music_converter/database/hive_boxes.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/database/interface/song_interface.dart';

class SplittedSongServices implements SplittedSongInterface {
  Box<Map> _box;

  Future<Box<Map>> openBox() {
    return PgHiveBoxes.openBox<Map>(PgHiveBoxes.songs);
  }

  @override
  addSong(List<Song> song) async {
    if (!(_box?.isOpen ?? false)) _box = await openBox();
    Map drum = song.first.toJson();
    Map voice = song.last.toJson();
    var splittedSongMap = {"drum": drum, "voice": voice};
    return _box.putAll(splittedSongMap);
  }

  @override
  Future<List<dynamic>> getSongs() async {
    if (!(_box?.isOpen ?? false)) _box = await openBox();
    return _box.values.map((e) => e).toList();
  }

  @override
  deleteSong(String key) async {
    if (!(_box?.isOpen ?? false)) _box = await openBox();
    await _box.delete(key);
  }
}
