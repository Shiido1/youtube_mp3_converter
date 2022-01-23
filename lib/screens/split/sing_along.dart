import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/screens/split/provider/split_song_provider.dart';
import 'package:mp3_music_converter/screens/split/split.dart';
import 'package:mp3_music_converter/screens/split/split_song_drawer.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/bottom_playlist_indicator.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:provider/provider.dart';
import 'package:mp3_music_converter/screens/split/mute_vocal_song_screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SingAlong extends StatefulWidget {
  @override
  _SingAlongState createState() => _SingAlongState();
}

class _SingAlongState extends State<SingAlong> {
  SplitSongProvider _songProvider;
  Song selectedSong;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  RefreshController _refreshController = RefreshController();
  bool hideDisclaimer = false;

  @override
  void initState() {
    _songProvider = Provider.of<SplitSongProvider>(context, listen: false);
    _songProvider.getSongs(false);
    getBoolDisclaimer();
    super.initState();
  }

  _onRefresh() async {
    await _songProvider.getSongs(false);
    _refreshController.refreshCompleted();
  }

  getBoolDisclaimer() async {
    bool exists =
        await preferencesHelper.doesExists(key: 'hideRecordDisclaimer');
    hideDisclaimer = exists
        ? await preferencesHelper.getBoolValues(key: 'hideRecordDisclaimer')
        : false;
  }

  toggleHideDisclaimer(bool val) {
    hideDisclaimer = val;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawerEnableOpenDragGesture: false,
      backgroundColor: AppColor.white.withOpacity(0.05),
      appBar: AppBar(
        backgroundColor: AppColor.black,
        title: TextViewWidget(
          text: 'Sing Along',
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
        actions: [
          Container(),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          //   child: TextButton(
          //       style: ButtonStyle(
          //           backgroundColor:
          //               MaterialStateProperty.all(Colors.red[700])),
          //       onPressed: () {
          //         synchronizeSplitSong(context);
          //       },
          //       child: Text('Sync split',
          //           style: TextStyle(color: Colors.white, fontSize: 17))),
          // )
        ],
      ),
      endDrawer: SplitSongDrawer(selectedSong, false),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: buildSongList(),
            ),
            BottomPlayingIndicator()
          ],
        ),
      ),
    );
  }

  Widget buildSongList() {
    return Consumer<SplitSongProvider>(builder: (_, _provider, __) {
      if (_provider.allSongs.length < 1) {
        return Center(
            child: TextViewWidget(text: 'No Song', color: AppColor.white));
      }
      return SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: ListView.builder(
          itemCount: _provider.allSongs.length,
          itemBuilder: (BuildContext context, int index) {
            Song _song = _provider.allSongs[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    int width = MediaQuery.of(context).size.width.floor();
                    print(hideDisclaimer);

                    if (!hideDisclaimer)
                      splitDisclaimer(
                          context: context,
                          hideDisclaimer: hideDisclaimer,
                          toggleHideDisclaimer: toggleHideDisclaimer,
                          song: _song,
                          width: width);
                    else
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => MuteVocalsScreen(
                            song: _song,
                            width: width,
                          ),
                        ),
                      );
                  },
                  child: ListTile(
                    leading: SizedBox(
                      width: 95,
                      height: 150,
                      child: _song?.image != null &&
                              _song.image.isNotEmpty &&
                              !(_song.image.toLowerCase().contains('ncta') &&
                                  _song.image
                                      .toLowerCase()
                                      .contains('placeholder'))
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
                          : Image.asset('assets/log.png'),
                    ),
                    title: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: TextViewWidget(
                        text: _song?.songName ?? 'Unknown',
                        color: AppColor.white,
                        textSize: 15,
                        fontFamily: 'Roboto-Regular',
                      ),
                      subtitle: TextViewWidget(
                        text: _song?.artistName ?? 'Unknown Artist',
                        color: AppColor.white,
                        textSize: 13,
                        fontFamily: 'Roboto-Regular',
                      ),
                    ),
                    trailing: InkWell(
                      onTap: () {
                        setState(() {
                          selectedSong = _song;
                        });
                        _scaffoldKey.currentState.openEndDrawer();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          AppAssets.dot,
                          color: AppColor.white,
                        ),
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
        ),
      );
    });
  }
}

Future<void> splitDisclaimer(
    {@required BuildContext context,
    @required bool hideDisclaimer,
    @required Song song,
    @required Function toggleHideDisclaimer,
    @required int width,
    muteAudio = true}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Color.fromRGBO(40, 40, 40, 1),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Please record with headset or microphone for better quality',
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  alignment: Alignment.centerLeft,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                        unselectedWidgetColor: Colors.white,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent),
                    child: CheckboxListTile(
                      value: hideDisclaimer,
                      onChanged: (val) {
                        setState(() {
                          hideDisclaimer = val;
                        });
                        toggleHideDisclaimer(val);
                      },
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(
                        'Do not show this again',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      activeColor: Colors.blue,
                    ),
                  ),
                )
              ],
            ),
            actions: [
              TextButton(
                child: Text('OK',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                onPressed: () {
                  print('value saved is $hideDisclaimer');
                  preferencesHelper.saveValue(
                      key: 'hideRecordDisclaimer', value: hideDisclaimer);
                  if (muteAudio)
                    Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => MuteVocalsScreen(
                          song: song,
                          width: width,
                        ),
                      ),
                    );
                  else
                    Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => Split(
                          song: song,
                          width: width,
                        ),
                      ),
                    );
                },
              ),
            ],
          );
        },
      );
    },
  );
}
