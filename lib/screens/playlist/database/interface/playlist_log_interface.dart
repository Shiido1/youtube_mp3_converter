import 'package:mp3_music_converter/screens/playlist/database/model/playlist_log.dart';

abstract class PlaylistLogInterface {
  init();

  addLogs(PlayListLog log);

  // returns a list of logs
  Future<List<PlayListLog>> getLogs();

  deleteLogs(int logId);
  deleteLog(var key);

  updateLogs(int logID, PlayListLog log);

  close();
}
