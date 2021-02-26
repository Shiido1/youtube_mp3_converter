import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  Color color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 150, bottom: 120),
      child: Drawer(
        child: Container(
          color: AppColor.transparent,
          child: Column(
            children: [
              Text(
                'God',
              )
            ],
          ),
        ),
      ),
    );
  }
}
