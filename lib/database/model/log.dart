class Log {
  String filePath;
  String fileName;
  String image;

  Log({
    this.filePath,
    this.fileName,
    this.image,

  });

  // to map
  Map<String, dynamic> toMap(Log log) {
    Map<String, dynamic> logMap = Map();
    logMap["filePath"] = log.filePath;
    logMap["fileName"] = log.fileName;
    logMap["image"] = log.image;

    return logMap;
  }

  Log.fromMap(Map logMap) {
    this.fileName = logMap["fileName"];
    this.filePath = logMap["filePath"];
    this.image = logMap["image"];
  }
}
