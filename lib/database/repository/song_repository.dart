import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/screens/splitted/database/split_services.dart';

import '../songs/song_service.dart';

class SongRepository {
  static SongServices _services;
  static bool isHive;

  static init() {
    _services = SongServices();
  }

  static addSong(Song song) => _services.addSong(song);
  static deleteSong(String key) => _services.deleteSong(key);
  static getSongs() => _services.getSongs();
  static getPlayLists() => _services.getPlayLists();
  static getFavoriteSongs() => _services.getFavoriteSongs();
  static Stream<List<Song>> streamAllSongs() => _services.streamAllSongs();
}

class SplittedSongRepository {
  static SplittedSongServices _services;
  static bool isHive;

  static init() {
    _services = SplittedSongServices();
  }

  static addSong(List<Song> song) async {
    await _services.addSong(song);
  }

  static deleteSong(String key) async {
    await _services.deleteSong(key);
  }

  static getSongs() async {
    _services.getSongs();
  }
}
