import 'package:flutter/material.dart';
import 'package:mp3_music_converter/screens/change_password.dart';
import 'package:mp3_music_converter/screens/dashboard/main_dashboard.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
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
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: AppColor.background,
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Stack(
              children: [
                Image.asset(AppAssets.rect),
                Column(
                  children: [
                    SizedBox(height: 65),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios_sharp,
                              color: AppColor.white,
                            ),
                            onPressed: () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MainDashBoard()),
                                )),
                        TextViewWidget(
                            color: AppColor.white,
                            text: 'Settings',
                            textSize: 22,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Montserrat'),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipOval(
                              child: Image.asset('assets/burna.png'),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: TextViewWidget(
                                    color: AppColor.white,
                                    text: 'Profile',
                                    textSize: 17,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Montserrat-Thin')),
                            SizedBox(
                              height: 90,
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 56.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextViewWidget(
                    text: 'Change Theme',
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
            Padding(
              padding: const EdgeInsets.only(left: 56.0),
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ChangePassword()),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextViewWidget(
                      text: 'Change Password',
                      color: AppColor.white,
                      textSize: 22,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(26.0),
              child: Divider(color: AppColor.white, height: 0.1),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 56.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextViewWidget(
                    text: 'Help',
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
            Padding(
              padding: const EdgeInsets.only(left: 56.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextViewWidget(
                    text: 'Notification',
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
            Padding(
              padding: const EdgeInsets.only(left: 56.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextViewWidget(
                    text: 'Privacy',
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
            Center(
              child: FlatButton(
                  color: AppColor.bottomRed,
                  onPressed: () {},
                  child: Text(
                    'Log Out',
                    style: TextStyle(
                      color: AppColor.white,
                      fontSize: 20,
                    ),
                  )),
            ),
            SizedBox(height: 20),
          ]),
        ),
      ),
    );
  }
}
