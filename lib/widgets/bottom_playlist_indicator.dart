import 'package:flutter/material.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';

import 'text_view_widget.dart';

class BottomPlayingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.black),
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: ListTile(
              leading: Image.asset(
                AppAssets.image1,
                height: 80,
              ),
              title: TextViewWidget(
                text: 'kofi',
                color: AppColor.white,
                textSize: 16,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextViewWidget(
                    text: 'Came Up',
                    color: AppColor.white,
                    textSize: 18,
                  ),
                  Divider(
                    thickness: 3,
                    color: AppColor.red,
                  )
                ],
              ),
              trailing: IconButton(
                  color: AppColor.white,
                  iconSize: 50,
                  icon: Icon(Icons.play_circle_outline),
                  onPressed: () {}),
            ),
          ),
        ),
        Divider(color: AppColor.white, height: 0.1),
      ],
    );
  }
}
