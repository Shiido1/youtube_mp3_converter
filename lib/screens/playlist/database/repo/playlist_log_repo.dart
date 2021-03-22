// import 'package:mp3_music_converter/database/model/log.dart';
import 'package:mp3_music_converter/screens/playlist/database/model/playlist_log.dart';
import 'package:mp3_music_converter/screens/playlist/database/playlist_db.dart';

class PlayListLogRepository {
  static var dbObject;
  static bool isHive;

  static init() {
    dbObject = PlaylistHive();
    dbObject.init();
  }

  static addLogs(PlayListLog log) => dbObject.addLogs(log);

  static deleteLogs(int logId) => dbObject.deleteLogs(logId);

  static deleteLog(var key) => dbObject.deleteLog(key);

  static getLogs() => dbObject.getLogs();

  static updateLogs(int logID, PlayListLog log) =>
      dbObject.updateLogs(logID, log);

  static close() => dbObject.close();
}
