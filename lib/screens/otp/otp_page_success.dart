import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/screens/dashboard/dashboard.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/page_router/navigator.dart';
import 'package:mp3_music_converter/widgets/button_widget.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';

class OtpPageSuccessful extends StatefulWidget {
  @override
  _OtpPageSuccessfulState createState() => _OtpPageSuccessfulState();
}

class _OtpPageSuccessfulState extends State<OtpPageSuccessful> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppColor.background,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 30, right: 30),
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              // ImageLoader(
              //   path: AppAssets.otpSuccessfulIcon,
              //   width: 277,
              //   height: 247,
              // ),
              SizedBox(
                height: 40,
              ),
              Container(
                margin: EdgeInsets.only(left: 77, right: 77),
                child: TextViewWidget(
                  text: 'Your account has been verified successfully',
                  color: AppColor.black,
                  textSize: 16,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 76,
              ),
              Container(
                width: getWidth(context),
                height: 44,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.blue.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 2,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: ButtonWidget(
                    color: AppColor.blue,
                    text: 'PROCEED TO CREATE PIN',
                    textColor: AppColor.white,
                    callback: () => PageRouter.gotoWidget(DashBoard(), context),
                    splashColor: AppColor.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
