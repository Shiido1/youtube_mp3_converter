import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'interface/log_interface.dart';
import 'model/log.dart';

class HiveMethods implements LogInterface {
  String hive_box = "musc_log";

  @override
  init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }

  @override
  addLogs(Log log) async {
    var box = await Hive.openBox(hive_box);

    var logMap = log.toMap(log);

    // box.put("custom_key", logMap);
    int idOfInput = await box.add(logMap);

    close();

    return idOfInput;
  }

  updateLogs(int i, Log newLog) async {
    var box = await Hive.openBox(hive_box);

    var newLogMap = newLog.toMap(newLog);

    box.putAt(i, newLogMap);

    close();
  }

  @override
  Future<List<Log>> getLogs() async {
    var box = await Hive.openBox(hive_box);

    List<Log> logList = [];

    for (int i = 0; i < box.length; i++) {
      var logMap = box.getAt(i);

      logList.add(Log.fromMap(logMap));
    }
    return logList;
  }

  @override
  deleteLogs(int logId) async {
    var box = await Hive.openBox(hive_box);

    await box.deleteAt(logId);
    // await box.delete(logId);
  }

  // @override
  // Future currentLogs(int clogs, Log clog) async {
  //   // ignore: todo
  //   // TODO: implement currentLogs
  //   // var box = await Hive.openBox(hive_box);

  //   // var newLogMap = clog.toMap(clog);

  //   // box.putAt(clogs, newLogMap);
  //   // return newLogMap;

  //   var box = await Hive.openBox(hive_box);

  //   var newLogMap = clog.toMap(clog);
  //   bool _recover = true;
  //   if (clogs != null) {
  //     box.putAt(clogs, newLogMap);
  //   } else {
  //     box =
  //         await _manager.open(hive_box, path ?? homePath, !_recover, newLogMap);
  //   }
  // }

  @override
  close() => Hive.close();
}
