import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/bottom_playlist_indicator.dart';
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
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [1, 2, 3, 4, 5, 6, 7]
                    .map((mocked) => Column(
                          children: [
                            ListTile(
                              onTap: () {},
                              leading: Image.asset(AppAssets.image1),
                              title: TextViewWidget(
                                text: 'Something Fishy',
                                color: AppColor.white,
                                textSize: 18,
                              ),
                              subtitle: TextViewWidget(
                                text: 'Davido',
                                color: AppColor.white,
                                textSize: 14,
                              ),
                              trailing: SvgPicture.asset(
                                AppAssets.dot,
                                color: AppColor.white,
                              ),
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
      ),
    );
  }
}
