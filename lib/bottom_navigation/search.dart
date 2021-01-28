import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _controller;

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
            // Padding(
            //   padding: const EdgeInsets.all(20.0),
            //   child: Stack(children: [
            //     Align(
            //       alignment: Alignment.centerLeft,
            //       child: Padding(
            //         padding: const EdgeInsets.all(10.0),
            //         child: Icon(
            //           Icons.search,
            //           color: AppColor.white,
            //           size: 30,
            //         ),
            //       ),
            //     ),
            //     TextFormField(
            //       decoration: new InputDecoration(
            //         enabledBorder: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(16.0),
            //           borderSide: BorderSide(color: AppColor.white),
            //         ),
            //         focusedBorder: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(16.0),
            //           borderSide: BorderSide(color: AppColor.white),
            //         ),
            //         border: new OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(16.0),
            //           borderSide: BorderSide(color: AppColor.white),
            //         ),
            //         labelText: 'Search',
            //         labelStyle: TextStyle(color: AppColor.white),
            //       ),
            //       cursorColor: AppColor.white,
            //     ),
            //     Align(
            //       alignment: Alignment.centerRight,
            //       child: Container(
            //         decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(18.0),
            //             border: Border.all(color: AppColor.white)),
            //         child: ClipOval(
            //           child: Material(
            //             color: AppColor.transparent, // button color
            //             child: InkWell(
            //               splashColor: AppColor.white, // inkwell color
            //               child: SizedBox(
            //                   width: 56,
            //                   height: 54,
            //                   child: Icon(
            //                     Icons.check,
            //                     color: AppColor.white,
            //                     size: 35,
            //                   )),
            //               onTap: () {},
            //             ),
            //           ),
            //         ),
            //       ),
            //     )
            //   ]),
            // ),
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
    );
  }
}
