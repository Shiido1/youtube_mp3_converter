import 'package:flutter/material.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/bottom_playlist_indicator.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  // TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColor.background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                        Image.asset(AppAssets.logo),
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
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12, left: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColor.transparent,
                      border: Border.all(
                        color: AppColor.background1,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    margin: EdgeInsets.all(12),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Icon(
                            Icons.search,
                            color: AppColor.white,
                            size: 20,
                          ),
                        ),
                        new Expanded(
                          child: TextField(
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search",
                              hintStyle: TextStyle(color: AppColor.white),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 12),
                              isDense: true,
                            ),
                            style: TextStyle(
                              fontSize: 14.0,
                              color: AppColor.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: ClipOval(
                            child: Material(
                              color: AppColor.transparent, // button color
                              child: InkWell(
                                splashColor: AppColor.white, // inkwell color
                                child: SizedBox(
                                    width: 36,
                                    height: 24,
                                    child: Icon(
                                      Icons.check,
                                      color: AppColor.white,
                                      size: 20,
                                    )),
                                onTap: () {},
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: SizedBox(
                height: 6.5,
              ),
            ),
            BottomPlayingIndicator(),
          ],
        ),
      ),
    );
  }
}
