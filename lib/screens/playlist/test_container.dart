import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mp3_music_converter/screens/dashboard/sample_dashboard.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';

class JayceeClass extends StatefulWidget {
  @override
  _JayceeClassState createState() => _JayceeClassState();
}

class _JayceeClassState extends State<JayceeClass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: AppColor.background,
        child: SingleChildScrollView(
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
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  icon: Icon(
                                    Icons.arrow_back_ios_sharp,
                                    color: AppColor.white,
                                  ),
                                  onPressed: () => Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Sample()),
                                      )),
                              TextViewWidget(
                                  color: AppColor.white,
                                  text: 'Create Your Music',
                                  textSize: 20,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Montserrat'),
                            ],
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
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
                                  height: 50,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
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
                height: MediaQuery.of(context).size.height / 3.9,
              ),
              Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                Container(
                  decoration: BoxDecoration(color: AppColor.black),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          AppAssets.image1,
                          height: 80,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextViewWidget(
                              text: 'kofi',
                              color: AppColor.white,
                              textSize: 16,
                            ),
                            TextViewWidget(
                              text: 'Came Up',
                              color: AppColor.white,
                              textSize: 20,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            SvgPicture.asset(AppAssets.line),
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SvgPicture.asset(AppAssets.play, height: 50, width: 80)
                      ],
                    ),
                  ),
                ),
                Divider(color: AppColor.white, height: 0.1),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
