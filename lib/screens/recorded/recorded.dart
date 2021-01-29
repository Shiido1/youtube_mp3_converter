import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';

class Recorded extends StatefulWidget {
  @override
  _RecordedState createState() => _RecordedState();
}

class _RecordedState extends State<Recorded> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.black,
        title: TextViewWidget(
          text: 'Recorded',
          color: AppColor.bottomRed,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: AppColor.bottomRed,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Image.asset(
                      AppAssets.image1,
                      height: 60,
                      width: 60,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextViewWidget(
                          text: 'Something Fishy',
                          color: AppColor.white,
                          textSize: 22,
                        ),
                        TextViewWidget(
                          text: 'davido',
                          color: AppColor.white,
                          textSize: 16,
                        )
                      ],
                    ),
                    SizedBox(
                      width: 85,
                    ),
                    SvgPicture.asset(
                      AppAssets.dot,
                      color: AppColor.white,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 30, top: 2.0, bottom: 2.0, left: 90),
                child: Divider(color: AppColor.white, height: 0.2),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Image.asset(
                      AppAssets.image1,
                      height: 60,
                      width: 60,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextViewWidget(
                          text: 'Something Fishy',
                          color: AppColor.white,
                          textSize: 22,
                        ),
                        TextViewWidget(
                          text: 'davido',
                          color: AppColor.white,
                          textSize: 16,
                        )
                      ],
                    ),
                    SizedBox(
                      width: 85,
                    ),
                    SvgPicture.asset(
                      AppAssets.dot,
                      color: AppColor.white,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 30, top: 2.0, bottom: 2.0, left: 90),
                child: Divider(color: AppColor.white, height: 0.2),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Image.asset(
                      AppAssets.image1,
                      height: 60,
                      width: 60,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextViewWidget(
                          text: 'Something Fishy',
                          color: AppColor.white,
                          textSize: 22,
                        ),
                        TextViewWidget(
                          text: 'davido',
                          color: AppColor.white,
                          textSize: 16,
                        )
                      ],
                    ),
                    SizedBox(
                      width: 85,
                    ),
                    SvgPicture.asset(
                      AppAssets.dot,
                      color: AppColor.white,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 30, top: 2.0, bottom: 2.0, left: 90),
                child: Divider(color: AppColor.white, height: 0.2),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Image.asset(
                      AppAssets.image1,
                      height: 60,
                      width: 60,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextViewWidget(
                          text: 'Something Fishy',
                          color: AppColor.white,
                          textSize: 22,
                        ),
                        TextViewWidget(
                          text: 'davido',
                          color: AppColor.white,
                          textSize: 16,
                        )
                      ],
                    ),
                    SizedBox(
                      width: 85,
                    ),
                    SvgPicture.asset(
                      AppAssets.dot,
                      color: AppColor.white,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 30, top: 2.0, bottom: 2.0, left: 90),
                child: Divider(color: AppColor.white, height: 0.2),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Image.asset(
                      AppAssets.image1,
                      height: 60,
                      width: 60,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextViewWidget(
                          text: 'Something Fishy',
                          color: AppColor.white,
                          textSize: 22,
                        ),
                        TextViewWidget(
                          text: 'davido',
                          color: AppColor.white,
                          textSize: 16,
                        )
                      ],
                    ),
                    SizedBox(
                      width: 85,
                    ),
                    SvgPicture.asset(
                      AppAssets.dot,
                      color: AppColor.white,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 30, top: 2.0, bottom: 2.0, left: 90),
                child: Divider(color: AppColor.white, height: 0.2),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Image.asset(
                      AppAssets.image1,
                      height: 60,
                      width: 60,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextViewWidget(
                          text: 'Something Fishy',
                          color: AppColor.white,
                          textSize: 22,
                        ),
                        TextViewWidget(
                          text: 'davido',
                          color: AppColor.white,
                          textSize: 16,
                        )
                      ],
                    ),
                    SizedBox(
                      width: 85,
                    ),
                    SvgPicture.asset(
                      AppAssets.dot,
                      color: AppColor.white,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 30, top: 2.0, bottom: 2.0, left: 90),
                child: Divider(color: AppColor.white, height: 0.2),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Image.asset(
                      AppAssets.image1,
                      height: 60,
                      width: 60,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextViewWidget(
                          text: 'Something Fishy',
                          color: AppColor.white,
                          textSize: 22,
                        ),
                        TextViewWidget(
                          text: 'davido',
                          color: AppColor.white,
                          textSize: 16,
                        )
                      ],
                    ),
                    SizedBox(
                      width: 85,
                    ),
                    SvgPicture.asset(
                      AppAssets.dot,
                      color: AppColor.white,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 30, top: 2.0, bottom: 2.0, left: 90),
                child: Divider(color: AppColor.white, height: 0.2),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Image.asset(
                      AppAssets.image1,
                      height: 60,
                      width: 60,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextViewWidget(
                          text: 'Something Fishy',
                          color: AppColor.white,
                          textSize: 22,
                        ),
                        TextViewWidget(
                          text: 'davido',
                          color: AppColor.white,
                          textSize: 16,
                        )
                      ],
                    ),
                    SizedBox(
                      width: 85,
                    ),
                    SvgPicture.asset(
                      AppAssets.dot,
                      color: AppColor.white,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 30, top: 2.0, bottom: 2.0, left: 90),
                child: Divider(color: AppColor.white, height: 0.2),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Image.asset(
                      AppAssets.image1,
                      height: 60,
                      width: 60,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextViewWidget(
                          text: 'Something Fishy',
                          color: AppColor.white,
                          textSize: 22,
                        ),
                        TextViewWidget(
                          text: 'davido',
                          color: AppColor.white,
                          textSize: 16,
                        )
                      ],
                    ),
                    SizedBox(
                      width: 85,
                    ),
                    SvgPicture.asset(
                      AppAssets.dot,
                      color: AppColor.white,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 30, top: 2.0, bottom: 2.0, left: 90),
                child: Divider(color: AppColor.white, height: 0.2),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Image.asset(
                      AppAssets.image1,
                      height: 60,
                      width: 60,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextViewWidget(
                          text: 'Something Fishy',
                          color: AppColor.white,
                          textSize: 22,
                        ),
                        TextViewWidget(
                          text: 'davido',
                          color: AppColor.white,
                          textSize: 16,
                        )
                      ],
                    ),
                    SizedBox(
                      width: 85,
                    ),
                    SvgPicture.asset(
                      AppAssets.dot,
                      color: AppColor.white,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    right: 30, top: 2.0, bottom: 2.0, left: 90),
                child: Divider(color: AppColor.white, height: 0.2),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Image.asset(
                      AppAssets.image1,
                      height: 60,
                      width: 60,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextViewWidget(
                          text: 'Something Fishy',
                          color: AppColor.white,
                          textSize: 22,
                        ),
                        TextViewWidget(
                          text: 'davido',
                          color: AppColor.white,
                          textSize: 16,
                        )
                      ],
                    ),
                    SizedBox(
                      width: 85,
                    ),
                    SvgPicture.asset(
                      AppAssets.dot,
                      color: AppColor.white,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child:
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
                          SvgPicture.asset(AppAssets.play,
                              height: 50, width: 80)
                        ],
                      ),
                    ),
                  ),
                  Divider(color: AppColor.white, height: 0.1),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
