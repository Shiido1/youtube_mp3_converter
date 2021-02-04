import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mp3_music_converter/screens/login/sign_in_screen.dart';
import 'package:provider/provider.dart';

import 'common/providers.dart';
import 'utils/color_assets/color.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: AppColor.red));
  runApp(MultiProvider(providers: Providers.getProviders, child: MyApp()));
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
        home: PlaylistScreen());
  }
}
