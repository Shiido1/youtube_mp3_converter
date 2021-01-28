import 'package:flutter/material.dart';
import 'package:mp3_music_converter/bottom_navigation/playlist.dart';
import 'package:mp3_music_converter/bottom_navigation/search.dart';
import 'package:mp3_music_converter/screens/converter/converter_screen.dart';
import 'package:mp3_music_converter/screens/playlist/music_screen.dart';
import 'package:mp3_music_converter/screens/playlist/play_list_screen.dart';
import 'package:mp3_music_converter/screens/dashboard/sample_dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        home: Sample());
  }
}
