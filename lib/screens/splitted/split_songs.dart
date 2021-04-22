import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/screens/splitted/provider/splitted_song_provider.dart';
import 'package:mp3_music_converter/screens/splitted/split_song_screen.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/bottom_playlist_indicator.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:provider/provider.dart';

class SplittedScreen extends StatefulWidget {
  @override
  _SplittedScreenState createState() => _SplittedScreenState();
}

class _SplittedScreenState extends State<SplittedScreen> {
  // ScrollController _scrollController;
  // List<bool> tap = [];
  // List<Song> splittedSongs = List.generate(59,
  //     (index) => Song(fileName: 'Something Fishy${index+1}', image: AppAssets.image1));

  SplittedSongProvider _splitSongProvider;

  @override
  void initState() {
    // tap = List.generate(splittedSongs.length, (index) => false);
    // _scrollController = ScrollController();

    _splitSongProvider = Provider.of<SplittedSongProvider>(context,listen:false);
    _splitSongProvider.getSongs();
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
      body: Center(
        child: Column(
          children: [
            Expanded(child: buildSongList(),
            //   child: ListView.builder(
            //     controller: _scrollController,
            //     itemCount: splittedSongs.length,
            //     itemBuilder: (context, index) {
            //       return Column(
            //         children: [
            //           ListTile(
            //             onTap: () {
            //               Navigator.push(
            //                 context,
            //                 MaterialPageRoute(
            //                     builder: (context) => SplitSongScreen()),
            //               );
            //             },
            //             leading: Image.asset(splittedSongs[index].image),
            //             title: TextViewWidget(
            //               text: splittedSongs[index].fileName,
            //               color: tap[index] ? AppColor.bottomRed : AppColor.white,
            //               textSize: 18,
            //             ),
            //             trailing: IconButton(
            //                 icon: tap[index]
            //                     ? Icon(Icons.expand_more_rounded)
            //                     : Icon(Icons.expand_less_rounded),
            //                 color: tap[index] ? AppColor.bottomRed : AppColor.white,
            //                 iconSize: 30,
            //                 onPressed: () {
            //                   setState(() {
            //                     for(int i =0; i<tap.length; i++){
            //                       if( i!= index)
            //                         tap[i] = false;
            //                     }
            //                    tap[index] = !tap[index];
            //                   });
            //
            //                   _scrollController.jumpTo(75.0*index);
            //                 }),
            //           ),
            //           SizedBox(
            //             height: 3,
            //           ),
            //           if (index != splittedSongs.length - 1)
            //             Padding(
            //               padding: const EdgeInsets.only(left: 70.0, right: 23),
            //               child: Divider(
            //                 color: tap[index]
            //                     ? Color.fromRGBO(80, 80, 80, 1)
            //                     : AppColor.white,
            //               ),
            //             ),
            //           Visibility(visible: tap[index], child: DropDownSplit()),
            //         ],
            //       );
            //     },
            //   ),
            ),
            BottomPlayingIndicator()
          ],
        ),
      ),
    );
  }

  Widget buildSongList() {
    return Consumer<SplittedSongProvider>(builder: (_, _provider, __) {
      if (_provider.allSongs.length < 1) {
        return Center(
            child: TextViewWidget(text: 'No Splitted Song', color: AppColor.white));
      }
      return ListView.builder(
        itemCount: _provider.allSongs.length,
        itemBuilder: (BuildContext context, int index) {
          Song _song = _provider.allSongs[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: SizedBox(
                    width: 95,
                    height: 150,
                    child: _song?.image != null && _song.image.isNotEmpty
                        ? CachedNetworkImage(
                      imageUrl: _song.image,
                      placeholder: (context, index) => Container(
                        child: Center(
                            child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator())),
                      ),
                      errorWidget: (context, url, error) =>
                      new Icon(Icons.error),
                    )
                        : null),
                title: GestureDetector(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SplitSongScreen()),
                    );
                  },
                  child: TextViewWidget(
                    text: _song?.fileName ?? '',
                    color: AppColor.white,
                    textSize: 15,
                    fontFamily: 'Roboto-Regular',
                  ),
                ),
                trailing: InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      AppAssets.record,
                      color: AppColor.white,
                    ),
                  ),
                ),
              ),
              if (_provider.allSongs.length - 1 != index)
                Padding(
                  padding: const EdgeInsets.only(left: 115.0, right: 15),
                  child: Divider(
                    color: AppColor.white,
                  ),
                )
            ],
          );
        },
      );
    });
  }
}
