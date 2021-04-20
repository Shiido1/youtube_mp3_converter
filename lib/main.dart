import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hive/hive.dart';
import 'package:mp3_music_converter/utils/utilFold/linkShareAssistant.dart';
import 'package:mp3_music_converter/database/hive_boxes.dart';
import 'package:mp3_music_converter/screens/converter/convert.dart';
import 'package:mp3_music_converter/screens/splash_sreen.dart';
import 'package:mp3_music_converter/utils/page_router/navigator.dart';
import 'package:provider/provider.dart';
import 'common/providers.dart';
import 'utils/color_assets/color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: debug);
  var path = Directory.current.path;
  Hive.init(path);
  await PgHiveBoxes.init();

  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: AppColor.red));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String _sharedText = "";

  @override
  void initState() {
    super.initState();

    // Create the share service
    LinkShareAssistant()
    // Register a callback so that we handle shared data if it arrives while the
    // app is running
      ..onDataReceived = _handleSharedData

    // Check to see if there is any shared data already, meaning that the app
    // was launched via sharing.
      ..getSharedData().then(_handleSharedData);
  }

  /// Handles any shared data we may receive.
  void _handleSharedData(String sharedData) {
    setState(() {
      _sharedText = sharedData;
    });
  }


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: Providers.getProviders,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        home: _sharedText.length > 1 && _sharedText != null ? Convert(sharedLinkText: _sharedText) : SplashScreenPage(),
        routes: Routes.getRoutes,
      ),
    );
  }
}
