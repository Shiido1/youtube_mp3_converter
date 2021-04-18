import 'package:flutter/material.dart';
import 'package:mp3_music_converter/database/model/song.dart';
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
  ScrollController _scrollController;
  List<bool> tap = [];
  List<Song> splittedSongs = List.generate(59,
      (index) => Song(fileName: 'Something Fishy${index+1}', image: AppAssets.image1));

  @override
  void initState() {
    tap = List.generate(splittedSongs.length, (index) => false);
    _scrollController = ScrollController();
    super.initState();
  }

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
            child: ListView.builder(
              controller: _scrollController,
              itemCount: splittedSongs.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SplitSongScreen()),
                        );
                      },
                      leading: Image.asset(splittedSongs[index].image),
                      title: TextViewWidget(
                        text: splittedSongs[index].fileName,
                        color: tap[index] ? AppColor.bottomRed : AppColor.white,
                        textSize: 18,
                      ),
                      trailing: IconButton(
                          icon: tap[index]
                              ? Icon(Icons.expand_more_rounded)
                              : Icon(Icons.expand_less_rounded),
                          color: tap[index] ? AppColor.bottomRed : AppColor.white,
                          iconSize: 30,
                          onPressed: () {
                            setState(() {
                              for(int i =0; i<tap.length; i++){
                                if( i!= index)
                                  tap[i] = false;
                              }
                             tap[index] = !tap[index];
                            });

                            _scrollController.jumpTo(75.0*index);
                          }),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    if (index != splittedSongs.length - 1)
                      Padding(
                        padding: const EdgeInsets.only(left: 70.0, right: 23),
                        child: Divider(
                          color: tap[index]
                              ? Color.fromRGBO(80, 80, 80, 1)
                              : AppColor.white,
                        ),
                      ),
                    Visibility(visible: tap[index], child: DropDownSplit()),
                  ],
                );
              },
            ),
          ),
          BottomPlayingIndicator()
        ],
      ),
    );
  }
}
