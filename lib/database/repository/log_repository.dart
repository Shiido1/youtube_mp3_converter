import 'package:mp3_music_converter/database/model/log.dart';

import '../hive_method.dart';

class LogRepository {
  static var dbObject;
  static bool isHive;

  static init() {
    dbObject = HiveMethods();
    dbObject.init();
  }

  static addLogs(Log log) => dbObject.addLogs(log);

  static deleteLogs(int logId) => dbObject.deleteLogs(logId);

  static getLogs() => dbObject.getLogs();

  static updateLogs(int logID, Log log) => dbObject.updateLogs(logID, log);

  static close() => dbObject.close();
}
