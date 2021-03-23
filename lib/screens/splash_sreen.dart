import 'package:flutter/material.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/page_router/navigator.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/image-loader.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    _startTime();
    super.initState();
  }

  _startTime() async {
    await Future.delayed(Duration(seconds: 7));
    PageRouter.gotoNamed(Routes.DASHBOARD, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: Center(
        child: ImageLoader(
          path: AppAssets.logo,
          height: 200,
          width: 200,
        ),
      ),
    );
  }
}
