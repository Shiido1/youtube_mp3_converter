import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mp3_music_converter/screens/login/sign_in_screen.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RedBackground extends StatefulWidget {
  final String text;
  final IconButton iconButton;
  final VoidCallback callback;

  RedBackground({this.text, this.iconButton, this.callback});

  @override
  _RedBackgroundState createState() => _RedBackgroundState();
}

class _RedBackgroundState extends State<RedBackground> {
  File image;
  bool img = false;
  SharedPreferences sharedPreferences;

  _checkLoginState() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString('token') == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => SignInScreen()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLoginState();
  }

  getGallery(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = picture;
      img = true;
    });
    Navigator.of(context).pop();
  }

  Future<void> _showDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Text(
                      'Logout',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      sharedPreferences.clear();
                      sharedPreferences.commit();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  SignInScreen()),
                          (Route<dynamic> route) => false);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: Text('Gallery'),
                    onTap: () {
                      getGallery(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/rect.png',
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.fitWidth,
        ),
        Container(
          margin: const EdgeInsets.only(left: 16, right: 16, top: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  widget.iconButton != null
                      ? Padding(
                          padding: const EdgeInsets.only(right: 3.0),
                          child: IconButton(
                              icon: widget.iconButton,
                              onPressed: widget.callback),
                        )
                      : TextViewWidget(text: '', color: AppColor.transparent),
                  widget.text != null
                      ? TextViewWidget(
                          color: AppColor.white,
                          text: widget.text,
                          textSize: 22,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Montserrat')
                      : Image.asset(AppAssets.logo),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  img == false ? ClipOval(
                    child: Image.asset('assets/burna.png'),
                  ):ClipOval(
                    child: Image.file(
                      image,
                      height: 70,
                      width: 70,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: InkWell(
                      onTap: () => _showDialog(context),
                      child: Text(
                        'Profile',
                        style: TextStyle(
                            fontSize: 17,
                            color: AppColor.white,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Montserrat-Thin'),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
