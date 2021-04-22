import 'dart:async';

import 'package:hive/hive.dart';
import 'package:mp3_music_converter/database/hive_boxes.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/database/interface/song_interface.dart';

class SplittedSongServices implements SplittedSongInterface {
  Box<List> _box;

  Future<Box<List>> openBox() {
    return PgHiveBoxes.openBox<List>(PgHiveBoxes.split);
  }

  @override
  addSong({String songName, List<Song> splittedSongs}) async {
    List split;
    splittedSongs.forEach((element) {
      if (element.fileName != 'failed') split.add(element.toJson());
    });

    // if (!(_box?.isOpen ?? false)) _box = await openBox();
    // Map drum = song.first.toJson();
    // Map voice = song.last.toJson();
    // var splittedSongMap = {"drum": drum, "voice": voice};
    // return _box.putAll(splittedSongMap);
    if (!(_box?.isOpen ?? false)) _box = await openBox();
    return _box.put(songName, splittedSongs);
  }

  @override
  Future<List> getSplittedSongName() async {
    if (!(_box?.isOpen ?? false)) _box = await openBox();
    return _box.keys.toList();
  }

  @override
  Future<List> getSplit(String key) async {
    if (!(_box?.isOpen ?? false)) _box = await openBox();
    return _box.get(key);
  }

  @override
  deleteSong(String key) async {
    if (!(_box?.isOpen ?? false)) _box = await openBox();
    await _box.delete(key);
  }
}
