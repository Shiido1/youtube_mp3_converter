import 'dart:io';

import 'package:hive/hive.dart';
import 'package:mp3_music_converter/database/interface/log_interface.dart';
import 'package:mp3_music_converter/screens/playlist/database/interface/playlist_log_interface.dart';
import 'package:mp3_music_converter/screens/playlist/database/model/playlist_log.dart';
// import 'package:mp3_music_converter/database/model/log.dart';
import 'package:path_provider/path_provider.dart';

class PlaylistHive implements PlaylistLogInterface {
  String hv_box = "playlist";

  @override
  init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }

  @override
  addLogs(PlayListLog log) async {
    Box<Map<String, Map>> box = await Hive.openBox<Map<String, Map>>(hv_box);
    Map<String, Map> map = Map<String, Map>();
    map[log.fileName] = log.toJson();
    await box.put(log.fileName, log.toJson());
    close();
    return;
  }

  @override
  close() => Hive.close();

  @override
  deleteLogs(int logId) async {
    var box = await Hive.openBox<Map<String, Map>>(hv_box);
    await box.deleteAt(logId);
  }

  @override
  deleteLog(var key) async {
    var box = await Hive.openBox<Map<String, Map>>(hv_box);
    await box.delete(key);
  }

  @override
  Future<List<PlayListLog>> getLogs() async {
    var box = await Hive.openBox<Map<String, Map>>(hv_box);
    return box
        .toMap()
        .values
        .map((e) => PlayListLog.fromMap(e?.values?.first ?? e))
        .toList();
  }

  @override
  updateLogs(int logID, PlayListLog log) {
    // TODO: implement p_updateLogs
    throw UnimplementedError();
  }
}
