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
    if (_box.containsKey(song.splittedFileName)) {
      Map savedSong = _box.get(song.splittedFileName);

      print(savedSong);
      String fileName = savedSong['fileName'];
      // String filePath = savedSong['filePath'];
      // String image = savedSong['image'];
      // String splittedFileName = savedSong['splittedFileName'];
      String vocalName = savedSong['vocalName'];

      song.fileName =
          fileName != null && fileName != '' ? fileName : song.fileName;
      song.vocalName =
          vocalName != null && fileName != '' ? vocalName : song.vocalName;

      print(song.vocalName);

      return _box.put(song.splittedFileName, song.toJson());

      // song.fileName = fileName != null ? fileName : song.fileName;
      // song.fileName = fileName != null ? fileName : song.fileName;
      // song.fileName = fileName != null ? fileName : song.fileName;

    }
    return _box.put(song.splittedFileName, song.toJson());
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

  getKeys() async {
    if (!(_box?.isOpen ?? false)) _box = await openBox();
    print(_box.keys);
  }
}
