import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:equalizer/equalizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mp3_music_converter/playlist/create_playlist_screen.dart';
import 'package:mp3_music_converter/screens/recorded/provider/record_provider.dart';
import 'package:mp3_music_converter/screens/recorded/recorded_drawer.dart';
import 'package:mp3_music_converter/screens/recorded/recorded_screen.dart';
import 'package:mp3_music_converter/screens/split/delete_song.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/bottom_playlist_indicator.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:provider/provider.dart';
import 'package:mp3_music_converter/screens/recorded/model/recorder_model.dart';

class Recorded extends StatefulWidget {
  @override
  _RecordedState createState() => _RecordedState();
}

class _RecordedState extends State<Recorded> {
  List<String> records;
  RecordProvider _recordProvider;
  RecorderModel selectedRecord;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  // String url =
  //     "https://www.techjockey.com/blog/wp-content/uploads/2019/09/Best-Call-Recording-Apps_feature.png";
  bool enabled = false;

  getEqualizerSettings() async {
    bool exists = await preferencesHelper.doesExists(key: 'enabled');
    Equalizer.init(0);
    if (exists) {
      enabled = await preferencesHelper.getBoolValues(key: 'enabled');
      Equalizer.setEnabled(enabled);
    }
  }

  @override
  void initState() {
    init();
    getEqualizerSettings();
    super.initState();
  }

  init() async {
    _recordProvider = Provider.of<RecordProvider>(context, listen: false);
    _recordProvider.getRecords();
    preferencesHelper
        .getStringValues(key: 'last_play_record')
        .then((value) async {
      if (value != null) {
        Map data = json.decode(value);
        RecorderModel item =
            RecorderModel(path: data['path'], name: data['name']);
        await _recordProvider.updateRecord(item);
      }
    });
  }

  @override
  void dispose() {
    if (_recordProvider.audioPlayerState != AudioPlayerState.STOPPED)
      _recordProvider.stopAudio();
    Equalizer.setEnabled(false);
    Equalizer.release();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawerEnableOpenDragGesture: false,
      backgroundColor: AppColor.white.withOpacity(0.05),
      key: _scaffoldKey,
      endDrawer: RecordedDrawer(
        model: selectedRecord,
      ),
      appBar: AppBar(
        backgroundColor: AppColor.black,
        title: TextViewWidget(
          text: 'Recorded Songs',
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
        actions: [Container()],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: buildSongList(),
            ),
            BottomPlayingIndicator(
              isMusic: false,
              enabled: enabled,
            )
          ],
        ),
      ),
    );
  }

  Widget buildSongList() {
    return Consumer<RecordProvider>(
      builder: (_, _provider, __) {
        if (_provider.allRecords.length < 1) {
          return Center(
              child: TextViewWidget(
                  text: 'No Recorded Song', color: AppColor.white));
        }
        return ListView.separated(
          itemCount: _provider.allRecords.length,
          itemBuilder: (_, int index) {
            List<RecorderModel> recordList = _provider.allRecords;
            recordList.sort((b, a) {
              return a.path
                  .split('/')
                  .last
                  .split('.')
                  .first
                  .compareTo(b.path.split('/').last.split('.').first);
            });
            RecorderModel record = recordList[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // showOptions(record);
                GestureDetector(
                  onTap: () async {
                    _recordProvider.records = recordList;
                    _recordProvider.setCurrentIndex(index);
                    Equalizer.setEnabled(enabled);

                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => RecordedScreen(
                          record: record,
                          enabled: enabled,
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: SizedBox(
                      width: 75,
                      height: 100,
                      child: Image.asset('assets/log.png'),
                    ),
                    title: TextViewWidget(
                      text: record.name,
                      color: AppColor.white,
                      textSize: 15,
                      fontFamily: 'Roboto-Regular',
                    ),
                    trailing: InkWell(
                      onTap: () {
                        setState(() {
                          selectedRecord = record;
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
              ],
            );
          },
          separatorBuilder: (_, int index) => Padding(
            padding: const EdgeInsets.only(left: 115.0, right: 15),
            child: Divider(
              color: AppColor.white,
            ),
          ),
        );
      },
    );
  }

  Future<void> showOptions(RecorderModel record) {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            backgroundColor: Color.fromRGBO(40, 40, 40, 1),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    createPlayListScreen(
                        showToastMessage: true,
                        message: 'Recording renamed successfully',
                        renameRecord: true,
                        oldPlayListName: record.name,
                        context: _);
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 10),
                    height: 50,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(0),
                      leading: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      title: Text(
                        'Rename Recording',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(_);
                    DeleteSongs(context)
                        .showConfirmDeleteDialog(record: record);
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 10),
                    height: 50,
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.delete, color: Colors.white),
                      title: Text(
                        'Delete Recording',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
