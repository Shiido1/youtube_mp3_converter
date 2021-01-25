import 'package:flutter/material.dart';
import 'package:mp3_music_converter/screens/dashboard.dart';
import 'package:mp3_music_converter/screens/home_page.dart';
import 'package:mp3_music_converter/screens/sample_dashboard.dart';
import 'package:mp3_music_converter/screens/sign_up_screen.dart';
import 'package:mp3_music_converter/screens/world_radio_screen.dart';

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
      home: WorldRadioClass(),
    );
  }
}
