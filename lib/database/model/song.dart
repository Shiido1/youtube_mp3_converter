import 'dart:io';

class Song {
  String filePath;
  String fileName = '';
  String image;
  String vocalName;
  bool playList = false;
  bool favorite = false;
  DateTime lastPlayDate;
  String splittedFileName;

  String get file => fileName == null || fileName == ''
      ? ''
      : File('$filePath/$fileName').uri.toString();

  Song(
      {this.filePath,
      this.fileName,
      this.image,
      this.playList,
      this.favorite,
      this.lastPlayDate,
      this.splittedFileName,
      this.vocalName});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> songMap = Map();
    songMap["filePath"] = filePath;
    songMap["fileName"] = fileName;
    songMap["image"] = image;
    songMap["file"] = file;
    songMap["playList"] = playList;
    songMap["favorite"] = favorite;
    songMap["lastPlayDate"] = lastPlayDate;
    songMap["splittedFileName"] = splittedFileName;
    songMap["vocalName"] = vocalName;
    return songMap;
  }

  Song.fromMap(Map songMap) {
    this.fileName = songMap["fileName"];
    this.filePath = songMap["filePath"];
    this.image = songMap["image"];
    this.playList = songMap["playList"] == null ? false : songMap["playList"];
    this.favorite = songMap["favorite"] == null ? false : songMap["favorite"];
    this.lastPlayDate =
        songMap["lastPlayDate"] == null ? null : songMap["lastPlayDate"];
    this.splittedFileName = songMap["splittedFileName"] == null
        ? null
        : songMap["splittedFileName"];
    this.vocalName = songMap["vocalName"] == null ? null : songMap["vocalName"];
  }
}
