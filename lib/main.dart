import 'package:flutter/material.dart';
import 'package:mp3_music_converter/download_save_screen.dart';
import 'package:mp3_music_converter/home_page.dart';
import 'package:mp3_music_converter/sign_in_screen.dart';
import 'package:mp3_music_converter/sign_up_screen.dart';

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
      home: SignUpScreen(),
    );
  }
}
