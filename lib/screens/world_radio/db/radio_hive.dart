import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class RadioHiveBox {
  static final radio = 'radio';

  static init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }

  static Future<Box<T>> openRadioBox<T>(String boxName) async {
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

  static Future<void> closeRadioBox<T>(String boxName) async {
    Box box;
    if (Hive.isBoxOpen(boxName)) {
      box = Hive.box<T>(boxName);
      box.close();
    }
  }

  static void clearRadioData() {
    _clearRadioBox(radio);
  }

  static _clearRadioBox<T>(String name) async {
    try {
      print('clearing box $name');
      final Box<T> _box = await openRadioBox<T>(name);
      await _box?.clear();
    } catch (_) {
      print('clear $name error: ${_.toString()}');
    }
  }
}
