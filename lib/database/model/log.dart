class Log {
  String filePath;
  String fileName;

  Log({
    this.filePath,
    this.fileName,
  });

  // to map
  Map<String, dynamic> toMap(Log log) {
    Map<String, dynamic> logMap = Map();
    logMap["filePath"] = log.filePath;
    logMap["fileName"] = log.fileName;

    return logMap;
  }

  Log.fromMap(Map logMap) {
    this.fileName = logMap["fileName"];
    this.filePath = logMap["filePath"];
  }
}
