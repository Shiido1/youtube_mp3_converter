class RecorderModel {
  String path;
  String name;
  int libid;
  String musicid;
  RecorderModel({this.path, this.name});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> recordedSongMap = Map();
    recordedSongMap['path'] = path;
    recordedSongMap['name'] = name;
    recordedSongMap['musicid'] = musicid;
    recordedSongMap['libid'] = libid;
    return recordedSongMap;
  }

  RecorderModel.fromMap(Map json) {
    this.path = json['path'];
    this.name = json['name'];
    this.libid = json['libid'];
    this.musicid = json['musicid'];
  }
}
