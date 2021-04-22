import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class PgHiveBoxes {
  static final songs = 'songs';
  static final playList = 'playList';

  static init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }

  static Future<Box<T>> openBox<T>(String boxName) async {
    Box<T> box;
    if (Hive.isBoxOpen(boxName)) {
      box = Hive.box<T>(boxName);
    } else {
      try {
        box = await Hive.openBox<T>(boxName);
      } catch (_) {
        await Hive.deleteBoxFromDisk(boxName);
        box = await Hive.openBox<T>(boxName);
      }
    }

    return box;
  }

  static Future<void> closeBox<T>(String boxName) async {
    Box box;
    if (Hive.isBoxOpen(boxName)) {
      box = Hive.box<T>(boxName);
      box.close();
    }
  }

  static void clearData() {
    _clearBox(songs);
    _clearBox(playList);
  }

  static _clearBox<T>(String name) async {
    try {
      print('clearing box $name');
      final Box<T> _box = await openBox<T>(name);
      await _box?.clear();
    } catch (_) {
      print('clear $name error: ${_.toString()}');
    }
  }
}

class SplitHiveBoxes {
  static final songs = 'songs';

  static init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }

  static Future<Box<T>> openBox<T>(String boxName) async {
    Box<T> box;
    if (Hive.isBoxOpen(boxName)) {
      box = Hive.box<T>(boxName);
    } else {
      try {
        box = await Hive.openBox<T>(boxName);
      } catch (_) {
        await Hive.deleteBoxFromDisk(boxName);
        box = await Hive.openBox<T>(boxName);
      }
    }

    return box;
  }

  static Future<void> closeBox<T>(String boxName) async {
    Box box;
    if (Hive.isBoxOpen(boxName)) {
      box = Hive.box<T>(boxName);
      box.close();
    }
  }

  static void clearData() {
    _clearBox(songs);
  }

  static _clearBox<T>(String name) async {
    try {
      print('clearing box $name');
      final Box<T> _box = await openBox<T>(name);
      await _box?.clear();
    } catch (_) {
      print('clear $name error: ${_.toString()}');
    }
  }
}

