import 'package:flutter/material.dart';
import 'package:mp3_music_converter/screens/dashboard/dashboard.dart';
import 'package:mp3_music_converter/screens/dashboard/main_dashboard.dart';
import 'package:mp3_music_converter/screens/playlist/play_list_screen.dart';
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
            iconButton: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_outlined,
                color: AppColor.white,
              ),
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MainDashBoard()),
              ),
            ),
            text: 'Playlist',
          ),
          Expanded(
            child: ListView(
              children: [1, 2, 3, 4, 5, 6, 7]
                  .map((mocked) => Column(
                        children: [
                          ListTile(
                            onTap: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PlayList()),
                            ),
                            leading: Image.asset(AppAssets.image1),
                            title: TextViewWidget(
                              text: 'Untitled Playlist',
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
