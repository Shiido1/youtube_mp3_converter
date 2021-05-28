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
      String fileName = savedSong['fileName'];
      String vocalName = savedSong['vocalName'];

      song.fileName =
          fileName != null && fileName != '' ? fileName : song.fileName;
      song.vocalName =
          vocalName != null && fileName != '' ? vocalName : song.vocalName;

      print(song.vocalName);

      return _box.put(song.splittedFileName, song.toJson());
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

  @override
  renameSong({String fileName, String artistName, String songName}) async {
    if (!(_box?.isOpen ?? false)) _box = await openBox();
    Song song = Song.fromMap(_box.get(fileName));
    song.artistName = artistName ?? 'Unknown Artist';
    song.songName = songName ?? 'Unknown';
    _box.put(fileName, song.toJson());
  }
}
