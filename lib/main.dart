import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hive/hive.dart';
import 'package:mp3_music_converter/database/hive_boxes.dart';
import 'package:mp3_music_converter/screens/converter/convert.dart';
import 'package:mp3_music_converter/screens/login/sign_in_screen.dart';
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
        home: SplashScreenPage(),
        routes: Routes.getRoutes,
      ),
    );
  }
}
