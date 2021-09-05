import 'dart:async';

import 'package:hive/hive.dart';
import 'package:mp3_music_converter/database/hive_boxes.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/database/interface/song_interface.dart';

class SplitSongServices implements SplitSongInterface {
  Box<Map> _box;
  Box<Map> _box2;

  Future<Box<Map>> openBox() {
    return SplitHiveBoxes.openBox<Map>(SplitHiveBoxes.songs);
  }

  Future<Box<Map>> openBox2() {
    return SplitHiveBoxes.openBox<Map>('downloads');
  }

  @override
  addSong(Song song) async {
    if (!(_box?.isOpen ?? false)) _box = await openBox();
    if (_box.containsKey(song.splitFileName)) {
      Map savedSong = _box.get(song.splitFileName);
      String fileName = savedSong['fileName'];
      String vocalName = savedSong['vocalName'];

      song.fileName =
          fileName != null && fileName != '' ? fileName : song.fileName;
      song.vocalName =
          vocalName != null && fileName != '' ? vocalName : song.vocalName;

      print(song.vocalName);

      return _box.put(song.splitFileName, song.toJson());
    }
    return _box.put(song.splitFileName, song.toJson());
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

  @override
  addDownload({String key, Song song}) async {
    if (!(_box2?.isOpen ?? false)) _box2 = await openBox2();
    _box2.put(key, song.toJson());
  }

  @override
  Future<Song> getDownload(String key) async {
    if (!(_box2?.isOpen ?? false)) _box2 = await openBox2();
    return Song.fromMap(_box2.get(key));
  }
}
