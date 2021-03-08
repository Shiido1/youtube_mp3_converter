import 'package:mp3_music_converter/database/model/log.dart';

abstract class LogInterface {
  init();

  addLogs(Log log);

  // returns a list of logs
  Future<List<Log>> getLogs();

  deleteLogs(int logId);

  // currentLogs(int cls, Log clogs);

  updateLogs(int logID, Log log);

  close();
}
