import 'package:flutter/material.dart';
import 'package:mp3_music_converter/screens/dashboard/main_dashboard.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/widgets/red_background.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColor.background,
        child:
        SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                RedBackground(
                  iconButton: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_outlined,
                      color: AppColor.white,
                    ),
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MainDashBoard()),
                    ),
                  ),
                  text: 'Setting',
                ),
                bodyContainer('Change Theme'),
                bodyContainer('Change Password'),
                bodyContainer('Help'),
                bodyContainer('Notification'),
                bodyContainer('Privacy'),


        ]),
            ),
      ),
    );
  }

  Widget bodyContainer(String text)=>Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 33.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextViewWidget(
                text: text,
                color: AppColor.white,
                textSize: 22,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(26.0),
          child: Divider(color: AppColor.white, height: 0.1),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    ),
  );
}
