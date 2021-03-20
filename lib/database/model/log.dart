class Log {
  String filePath;
  String fileName;
  String image;
  String file;

  Log({
    this.filePath,
    this.fileName,
    this.image,
    this.file,
  });

  // to map
  Map<String, dynamic> toMap(Log log) {
    Map<String, dynamic> logMap = Map();
    logMap["filePath"] = log.filePath;
    logMap["fileName"] = log.fileName;
    logMap["image"] = log.image;
    logMap["file"] = log.file;

    return logMap;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> logMap = Map();
    logMap["filePath"] = filePath;
    logMap["fileName"] = fileName;
    logMap["image"] = image;
    logMap["file"] = file;
    return logMap;
  }

  Log.fromMap(Map logMap) {
    this.fileName = logMap["fileName"];
    this.filePath = logMap["filePath"];
    this.image = logMap["image"];
    this.file = logMap["file"];
  }
}
