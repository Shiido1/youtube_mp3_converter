import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mp3_music_converter/screens/dashboard/sample_dashboard.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';

class Convert extends StatefulWidget {
  @override
  _ConvertState createState() => _ConvertState();
}

class _ConvertState extends State<Convert> {
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
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                  text: 'Converter',
                                  textSize: 22,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Montserrat'),
                            ],
                          ),
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
                                height: 160,
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
                padding: const EdgeInsets.only(top: 6, bottom: 6, left: 30),
                child: TextViewWidget(
                    color: AppColor.white,
                    text: 'Enter Youtube Url',
                    textSize: 23,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Montserrat'),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Stack(children: [
                  TextFormField(
                    decoration: new InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      border: new OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      labelText: 'Enter Youtube Url',
                      labelStyle: TextStyle(color: Colors.white),
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
                          color: Color(0x00000), // button color
                          child: InkWell(
                            splashColor: Colors.white, // inkwell color
                            child: SizedBox(
                                width: 56,
                                height: 55.5,
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
              SizedBox(
                height: 203,
              ),
              Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                Container(
                  decoration: BoxDecoration(color: Colors.black),
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
