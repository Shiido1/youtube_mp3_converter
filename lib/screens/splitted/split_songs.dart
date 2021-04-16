import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mp3_music_converter/screens/splitted/split_song_screen.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/bottom_playlist_indicator.dart';
import 'package:mp3_music_converter/widgets/drop_down_split.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:mp3_music_converter/screens/splitted/provider/splitted_song_provider.dart';
import 'package:provider/provider.dart';
import 'package:mp3_music_converter/database/model/song.dart';

class SplittedScreen extends StatefulWidget {
  @override
  _SplittedScreenState createState() => _SplittedScreenState();
}

class _SplittedScreenState extends State<SplittedScreen> {
  SplittedSongProvider _splittedSongProvider;
  bool tap = false;
  int _selectedIndex = -1;

  @override
  void initState() {
    _splittedSongProvider =
        Provider.of<SplittedSongProvider>(context, listen: false);
    _splittedSongProvider.getSongs();
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

  buildSplitSongList() {
    return Consumer<SplittedSongProvider>(
      builder: (_, _provider, __) {
        if (_provider.allSongs.length < 1) {
          return Center(
              child: TextViewWidget(text: 'No Song', color: AppColor.white));
        }
        return ListView.builder(
          shrinkWrap: true,
          itemCount: _provider.allSongs.length,
          itemBuilder: (_, index) {
            var _song = _provider.allSongs[index];
            return Column(
              children: [
                ExpansionTile(
                  leading: SizedBox(
                      width: 95,
                      height: 150,
                      child: _song["drum"] != null &&
                              _song["drum"]["image"].isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: _song["drum"]["image"],
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
                  title: Text(''),
                  onExpansionChanged: ((change) {
                    if (change) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    }
                  }),
                  children: [
                    Container(
                      height: 100,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ListTile(
                            leading: CachedNetworkImage(
                              imageUrl: _song["drum"]["image"],
                              placeholder: (context, index) => Container(
                                child: Center(
                                    child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator())),
                              ),
                              errorWidget: (context, url, error) =>
                                  new Icon(Icons.error),
                            ),
                            title: Text(_song["drum"]["fileName"]),
                            subtitle: Text(_song["drum"]["filePath"]),
                          ),
                          ListTile(
                            leading: CachedNetworkImage(
                              imageUrl: _song["voice"]["image"],
                              placeholder: (context, index) => Container(
                                child: Center(
                                    child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator())),
                              ),
                              errorWidget: (context, url, error) =>
                                  new Icon(Icons.error),
                            ),
                            title: Text(_song["voice"]["fileName"]),
                            subtitle: Text(_song["voice"]["filePath"]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 3,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 70.0, right: 23),
                  child: Divider(
                    color: AppColor.white,
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }
}
