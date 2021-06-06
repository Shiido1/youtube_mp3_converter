import 'package:flutter/material.dart';
import 'package:mp3_music_converter/screens/change_password/forgot_password_email_screen.dart';
import 'package:mp3_music_converter/screens/search_follow/search_follow.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/widgets/red_background_backend/red_background.dart';
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
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            RedBackground(
              text: 'Setting',
            ),
            bodyContainer(
              text: 'Change Theme',
            ),
            bodyContainer(text: 'Forgot Password', screen: ForgotPassword()),
            bodyContainer(text: 'Search User', screen: SearchFollow()),
            bodyContainer(text: 'Notification'),
            bodyContainer(text: 'Privacy'),
          ]),
        ),
      ),
    );
  }

  Widget bodyContainer({
    String text,
    Widget screen,
  }) =>
      InkWell(
        onTap: () {
          screen == null
              ? Scaffold(
                  backgroundColor: AppColor.background,
                  appBar: AppBar(
                    backgroundColor: AppColor.bottomRed,
                    leading: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back_ios_sharp,
                        color: AppColor.white,
                      ),
                    ),
                  ),
                  body: Center(
                      child: TextViewWidget(
                    text: 'Coming Soon...!',
                    color: AppColor.white,
                    textSize: 18,
                  )),
                )
              : Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => screen),
                );
        },
        child: Container(
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
        ),
      );
}
