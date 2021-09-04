import 'dart:math';
import 'package:hive/hive.dart';
import 'package:mp3_music_converter/database/hive_boxes.dart';
import 'package:mp3_music_converter/screens/recorded/model/recorder_model.dart';

class RecorderServices {
  Box<Map> _box;

  Future<Box<Map>> openBox() {
    return PgHiveBoxes.openBox<Map>('recorded');
  }

  addRecording(RecorderModel recording) async {
    if (!(_box?.isOpen ?? false)) _box = await openBox();
    List<int> value = [];
    if (_box.isNotEmpty) {
      _box.keys.forEach((element) {
        if (element.toString().split(' ').first == 'Record') {
          value.add(int.tryParse(element.toString().split(' ').last));
        }
      });
      recording.name = value.isNotEmpty
          ? 'Record ${value.reduce(max) + 1}' ?? 'Record 1'
          : 'Record 1';
      print(recording.name);
      print(recording.path);
      _box.put(recording.name, recording.toJson());
    }
    if (_box.isEmpty) {
      recording.name = 'Record 1';
      print(recording.name);
      print(recording.path);
      _box.put(recording.name, recording.toJson());
    }
  }

  Future<bool> editRecording(RecorderModel recording,
      {String musicid, int libid}) async {
    if (!(_box?.isOpen ?? false)) _box = await openBox();
    Map record = _box.get(recording.name);
    record['libid'] = libid;
    record['musicid'] = musicid;
    await _box.delete(recording.name);
    _box.put(record['name'], record);
    return true;
  }

  renameRecording({String oldName, String newName}) async {
    if (!(_box?.isOpen ?? false)) _box = await openBox();
    Map recording = _box.get(oldName);
    recording['name'] = newName;
    await _box.delete(oldName);
    _box.put(newName, recording);
  }

  deleteRecording(String key) async {
    if (!(_box?.isOpen ?? false)) _box = await openBox();
    await _box.delete(key);
  }

  getRecordings() async {
    if (!(_box?.isOpen ?? false)) _box = await openBox();
    return _box.values
        .map((e) => e)
        .map((e) => RecorderModel.fromMap(e))
        .toList();
  }

  clear() async {
    if (!(_box?.isOpen ?? false)) _box = await openBox();
    await _box.clear();
  }
}
