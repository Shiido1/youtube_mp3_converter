import 'package:flutter/material.dart';
import 'package:mp3_music_converter/bottom_navigation/setting.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: AppBar(
          backgroundColor: AppColor.black,
          title: TextViewWidget(
            text: 'Update Password',
            color: AppColor.bottomRed,
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Setting()));
            },
            icon: Icon(
              Icons.arrow_back_ios_sharp,
              color: AppColor.bottomRed,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Theme(
                data: new ThemeData(hintColor: AppColor.white),
                child: TextField(
                    // focusNode: _focusUsername,
                    controller: _controller,
                    decoration: InputDecoration(
                        hintText: 'Current Password',
                        focusColor: AppColor.white,
                        hoverColor: AppColor.white)),
              ),
              TextField(),
              TextField(),
              Center(
                child: TextButton(
                    style: TextButton.styleFrom(
                      primary: AppColor.bottomRed,
                    ),
                    onPressed: () {},
                    child: Text(
                      'Update Password',
                      style: TextStyle(
                        color: AppColor.white,
                        fontSize: 20,
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
