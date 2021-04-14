import 'package:flutter/material.dart';
import 'package:mp3_music_converter/screens/splitted/split_song_screen.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/bottom_playlist_indicator.dart';
import 'package:mp3_music_converter/widgets/drop_down_split.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';

class SplittedScreen extends StatefulWidget {
  @override
  _SplittedScreenState createState() => _SplittedScreenState();
}

class _SplittedScreenState extends State<SplittedScreen> {
  bool tap = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.black,
        title: TextViewWidget(
          text: 'Splitted Songs',
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
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [1, 2, 3, 4, 5, 6, 7]
                  .map((mocked) => Column(
                        children: [
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SplitSongScreen()),
                              );
                            },
                            leading: Image.asset(AppAssets.image1),
                            title: TextViewWidget(
                              text: 'Something Fishy',
                              color: AppColor.white,
                              textSize: 18,
                            ),

                            trailing: IconButton(
                              onPressed: () {
                                setState(() {
                                  tap = !tap;
                                });
                                if (tap = true) {
                                  DropDownSplit();
                                } else {
                                  return;
                                }
                              },
                              icon: tap
                                  ? Icon(Icons.expand_more_rounded)
                                  : Icon(Icons.expand_less_rounded),
                              color: AppColor.white,
                              iconSize: 30,
                            ),
                            // Expanded(
                            //   child: Row(
                            //     children: [
                            //       IconButton(
                            //           icon: tap
                            //               ? Icon(Icons.expand_more_rounded)
                            //               : Icon(Icons.expand_less_rounded),
                            //           onPressed: () => setState(() {
                            //                 tap = !tap;
                            //                 if (tap = true) {
                            //                   DropDownSplit();
                            //                 } else {
                            //                   return;
                            //                 }
                            //               })),
                            //       SvgPicture.asset(
                            //         AppAssets.dot,
                            //         color: AppColor.white,
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 70.0, right: 23),
                            child: Divider(
                              color: AppColor.white,
                            ),
                          )
                        ],
                      ))
                  .toList(),
            ),
          ),
          BottomPlayingIndicator()
        ],
      ),
    );
  }
}
