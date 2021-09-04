import 'dart:io';

class Song {
  String filePath;
  String fileName = '';
  String songName = 'Unknown';
  String image;
  String vocalName;
  int libid;
  int vocalLibid;
  String musicId;
  String artistName = 'Unknown';
  bool favorite = false;
  DateTime lastPlayDate;
  String splittedFileName;

  String get file => fileName == null || fileName == ''
      ? ''
      : File('$filePath/$fileName').uri.toString();

  Song(
      {this.filePath,
      this.fileName,
      this.musicId,
      this.image,
      this.songName,
      this.artistName,
      this.vocalLibid,
      this.favorite,
      this.lastPlayDate,
      this.splittedFileName,
      this.libid,
      this.vocalName});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> songMap = Map();
    songMap["filePath"] = filePath;
    songMap["fileName"] = fileName;
    songMap["songName"] = songName;
    songMap["artistName"] = artistName;
    songMap["image"] = image;
    songMap['libid'] = libid;
    songMap['vocalLibid'] = vocalLibid;
    songMap["file"] = file;
    songMap["favorite"] = favorite;
    songMap["lastPlayDate"] = lastPlayDate;
    songMap["splittedFileName"] = splittedFileName;
    songMap["vocalName"] = vocalName;
    songMap["musicId"] = musicId;
    return songMap;
  }

  Song.fromMap(Map songMap) {
    this.fileName = songMap["fileName"];
    this.songName = songMap["songName"];
    this.artistName = songMap["artistName"];
    this.filePath = songMap["filePath"];
    this.image = songMap["image"];
    this.musicId = songMap["musicId"];
    this.vocalLibid = songMap['vocalLibid'];
    this.libid = songMap['libid'];
    this.favorite = songMap["favorite"] == null ? false : songMap["favorite"];
    this.lastPlayDate =
        songMap["lastPlayDate"] == null ? null : songMap["lastPlayDate"];
    this.splittedFileName = songMap["splittedFileName"] == null
        ? null
        : songMap["splittedFileName"];
    this.vocalName = songMap["vocalName"] == null ? null : songMap["vocalName"];
  }
}
