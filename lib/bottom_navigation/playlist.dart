import 'package:flutter/material.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/bottom_playlist_indicator.dart';
import 'package:mp3_music_converter/widgets/red_background.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';

class PlayList extends StatefulWidget {
  @override
  _PlayListState createState() => _PlayListState();
}

class _PlayListState extends State<PlayList> {
  // int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      body: Column(
        children: [
          RedBackground(
            text: 'Playlist',
          ),
          Expanded(
            child: ListView(
              children: [1, 2, 3, 4, 5, 6, 7]
                  .map((mocked) => Column(
                        children: [
                          ListTile(
                            leading: Image.asset(AppAssets.image1),
                            title: TextViewWidget(
                              text: 'Jaybankz',
                              color: AppColor.white,
                              textSize: 18,
                            ),
                            trailing: Icon(
                              Icons.navigate_next_sharp,
                              color: AppColor.white,
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Divider(
                            color: AppColor.white,
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
