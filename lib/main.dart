import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:mp3_music_converter/screens/converter/convert.dart';
import 'package:mp3_music_converter/screens/dashboard/main_dashboard.dart';
import 'package:mp3_music_converter/utils/page_router/navigator.dart';
import 'package:provider/provider.dart';
import 'common/providers.dart';
import 'database/repository/log_repository.dart';
import 'utils/color_assets/color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: debug // optional: set false to disable printing logs to console
      );
  LogRepository.init();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: AppColor.red));
  runApp(MultiProvider(providers: Providers.getProviders, child: MyApp()));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: Convert(),
      routes: Routes.getRoutes,
    );
  }
}
