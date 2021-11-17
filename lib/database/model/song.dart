import 'dart:io';

class Song {
  String filePath;
  String fileName = '';
  String songName = 'Unknown';
  String image;
  String vocalName;
  List artWork;
  int libid;
  int vocalLibid;
  String musicid;
  int size;
  String artistName = 'Unknown';
  bool favorite = false;
  DateTime lastPlayDate;
  String splitFileName;

  String get file => fileName == null || fileName == ''
      ? ''
      : File('$filePath/$fileName').uri.toString();

  Song(
      {this.filePath,
      this.fileName,
      this.musicid,
      this.image,
      this.songName,
      this.artistName,
      this.vocalLibid,
      this.favorite,
      this.size,
      this.artWork,
      this.lastPlayDate,
      this.splitFileName,
      this.libid,
      this.vocalName});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> songMap = Map();
    songMap["filePath"] = filePath;
    songMap["fileName"] = fileName;
    songMap["songName"] = songName;
    songMap["artistName"] = artistName;
    songMap["size"] = size;
    songMap["image"] = image;
    songMap["artWork"] = artWork;
    songMap['libid'] = libid;
    songMap['vocalLibid'] = vocalLibid;
    songMap["file"] = file;
    songMap["favorite"] = favorite;
    songMap["lastPlayDate"] = lastPlayDate;
    songMap["splitFileName"] = splitFileName;
    songMap["vocalName"] = vocalName;
    songMap["musicid"] = musicid;
    return songMap;
  }

  Song.fromMap(Map songMap) {
    this.fileName = songMap["fileName"];
    this.songName = songMap["songName"];
    this.artistName = songMap["artistName"];
    this.filePath = songMap["filePath"];
    this.image = songMap["image"];
    this.size = songMap["size"];
    this.musicid = songMap["musicid"];
    this.artWork = songMap["artWork"];
    this.vocalLibid = songMap['vocalLibid'];
    this.libid = songMap['libid'];
    this.favorite = songMap["favorite"] == null ? false : songMap["favorite"];
    this.lastPlayDate =
        songMap["lastPlayDate"] == null ? null : songMap["lastPlayDate"];
    this.splitFileName =
        songMap["splitFileName"] == null ? null : songMap["splitFileName"];
    this.vocalName = songMap["vocalName"] == null ? null : songMap["vocalName"];
  }
}
