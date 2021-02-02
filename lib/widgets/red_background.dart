import 'package:flutter/material.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';

class RedBackground extends StatelessWidget {
  final String text;
  final IconButton iconButton;
  final VoidCallback callback;

  RedBackground({this.text, this.iconButton, this.callback});

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
                  iconButton != null
                      ? Padding(
                          padding: const EdgeInsets.only(right: 3.0),
                          child:
                              IconButton(icon: iconButton, onPressed: callback),
                        )
                      : TextViewWidget(text: '', color: AppColor.transparent),
                  text != null
                      ? TextViewWidget(
                          color: AppColor.white,
                          text: text,
                          textSize: 22,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Montserrat')
                      : Image.asset(AppAssets.logo),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Image.asset('assets/burna.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      'Profile',
                      style: TextStyle(
                          fontSize: 17,
                          color: AppColor.white,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat-Thin'),
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
