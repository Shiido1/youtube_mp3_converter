import 'package:flutter/material.dart';
import 'package:mp3_music_converter/screens/dashboard/main_dashboard.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/widgets/bottom_playlist_indicator.dart';
import 'package:mp3_music_converter/widgets/red_background.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';

class CreateMusicScreen extends StatefulWidget {
  @override
  _CreateMusicScreenState createState() => _CreateMusicScreenState();
}

class _CreateMusicScreenState extends State<CreateMusicScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: AppColor.background,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RedBackground(
                      iconButton: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_outlined,
                          color: AppColor.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      text: 'Create Your Music',
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Stack(children: [
                        TextFormField(
                          decoration: new InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: BorderSide(color: AppColor.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: BorderSide(color: AppColor.white),
                            ),
                            border: new OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: BorderSide(color: AppColor.white),
                            ),
                            labelText: 'Upload Song',
                            labelStyle: TextStyle(color: AppColor.white),
                          ),
                          cursorColor: AppColor.white,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18.0),
                                border: Border.all(color: AppColor.white)),
                            child: ClipOval(
                              child: Material(
                                color: AppColor.transparent, // button color
                                child: InkWell(
                                  splashColor: AppColor.white, // inkwell color
                                  child: SizedBox(
                                      width: 56,
                                      height: 54,
                                      child: Icon(
                                        Icons.check,
                                        color: AppColor.white,
                                        size: 35,
                                      )),
                                  onTap: () {},
                                ),
                              ),
                            ),
                          ),
                        )
                      ]),
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextViewWidget(
                              text: 'From Library',
                              color: AppColor.white,
                              textSize: 22,
                            ),
                            SizedBox(
                              width: 25,
                            ),
                            IconButton(
                              icon: Icon(Icons.arrow_forward_ios_outlined),
                              onPressed: () {},
                              color: AppColor.white,
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(44, 10, 44, 10),
                          child: Divider(color: AppColor.white, height: 2),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextViewWidget(
                              text: 'From Device',
                              color: AppColor.white,
                              textSize: 22,
                            ),
                            SizedBox(
                              width: 25,
                            ),
                            IconButton(
                              icon: Icon(Icons.arrow_forward_ios_outlined),
                              onPressed: () {},
                              color: AppColor.white,
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 4.5,
                    ),
                  ],
                ),
              ),
            ),
            BottomPlayingIndicator(),
          ],
        ),
      ),
    );
  }
}
