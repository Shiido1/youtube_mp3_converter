import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/database/model/song.dart';

class ProviderClass extends ChangeNotifier {
  ProviderClass({this.themeData});

  ThemeData themeData;
  List<Song> allSongs = [];
  List<Song> recentlyAdded = [];

  ThemeData get theme => themeData;

  setTheme(ThemeData data) {
    themeData = data;
    notifyListeners();
  }
}
