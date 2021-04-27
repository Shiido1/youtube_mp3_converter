import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/utils/page_router/navigator.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RedBackground extends StatefulWidget {
  final String text;
  final IconButton iconButton;
  final VoidCallback callback;
  final Widget widgetContainer;


  RedBackground({this.text, this.iconButton, this.callback, this.widgetContainer});

  @override
  _RedBackgroundState createState() => _RedBackgroundState();
}

class _RedBackgroundState extends State<RedBackground> {
  File image;
  bool img = false;
  SharedPreferences sharedPreferences;
  bool newUser;
  bool logOut = false;

  _checkLoginState() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString('token') == null) {
      PageRouter.gotoNamed(Routes.LOGIN, context);
    }
  }

  void checkLogin() async {
    sharedPreferences = await SharedPreferences.getInstance();
    newUser = (sharedPreferences.getBool('login') ?? true);
    PageRouter.gotoNamed(Routes.LOGIN, context);
    setState(() {
      logOut = true;
    });

    if (newUser == false) {
      PageRouter.gotoNamed(Routes.DASHBOARD, context);
    }
  }

  getGallery(BuildContext context) async {
    // ignore: deprecated_member_use
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = picture;
      img = true;
    });
    Navigator.of(context).pop();
    preferencesHelper.saveValue(key: 'profileimage', value: image);
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
                      _checkLoginState();
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
  void initState() {
    // init();

    super.initState();
  }

  init() {
    if (image == null) {
      preferencesHelper
          .getCachedData(key: 'profileimage')
          .then((value) => setState(() {
                image = value;
              }));
      return image;
    }
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
                      ? IconButton(
                          icon: widget.iconButton,
                          onPressed: widget.callback)
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
              widget.widgetContainer !=null
                  ? _widgetContainer():
                  Container()
            ],
          ),
        ),
      ],
    );
  }
  Widget _widgetContainer()=>Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      img == false
          ? ClipOval(
        child: Image.asset('assets/burna.png'),
      )
          : Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image: FileImage(image), // picked file
                fit: BoxFit.cover)),
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
  );
}
