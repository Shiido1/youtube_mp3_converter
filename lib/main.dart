import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:hive/hive.dart';
import 'package:mp3_music_converter/download/download_save_screen.dart';
import 'package:mp3_music_converter/screens/converter/converter_screen.dart';
import 'package:mp3_music_converter/screens/converter/model/youtube_model.dart';
import 'package:mp3_music_converter/screens/playlist/play_list_screen.dart';
import 'package:mp3_music_converter/screens/song/song_view.dart';
import 'package:mp3_music_converter/screens/song/songs_screen.dart';
import 'package:mp3_music_converter/screens/world_radio/world_radio_screen.dart';
import 'package:mp3_music_converter/utils/page_router/navigator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'common/providers.dart';
import 'utils/color_assets/color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );
  final appDocument = await getExternalStorageDirectory();
  Hive.init(appDocument.path);
  Hive.registerAdapter(DownloadedFileAdapter());
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
      // home: DownloadAndSaveScreen(),
      home: FutureBuilder(
        future: Hive.openBox('music_db'),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError)
              return Text(snapshot.error.toString());
            else
              return WorldRadioClass();
          } else
            return Scaffold();
        },
      ),
      routes: Routes.getRoutes,
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
