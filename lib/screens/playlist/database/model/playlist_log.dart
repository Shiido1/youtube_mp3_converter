class PlayListLog {
  String filePath;
  String fileName;
  String image;
  String file;

  PlayListLog({
    this.filePath,
    this.fileName,
    this.image,
    this.file,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> logMap = Map();
    logMap["filePath"] = filePath;
    logMap["fileName"] = fileName;
    logMap["image"] = image;
    logMap["file"] = file;
    return logMap;
  }

  PlayListLog.fromMap(Map logMap) {
    this.fileName = logMap["fileName"];
    this.filePath = logMap["filePath"];
    this.image = logMap["image"];
    this.file = logMap["file"];
  }
}
