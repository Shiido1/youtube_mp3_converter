import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mp3_music_converter/playlist/create_playlist_screen.dart';
import 'package:mp3_music_converter/screens/recorded/provider/record_provider.dart';
import 'package:mp3_music_converter/screens/recorded/recorded_screen.dart';
import 'package:mp3_music_converter/screens/splitted/delete_song.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/page_router/navigator.dart';
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
  Directory appDir;
  List<String> records;
  RecordProvider _recordProvider;

  @override
  void initState() {
    // records = [];
    _recordProvider = Provider.of<RecordProvider>(context, listen: false);
    _recordProvider.getRecords();
    // getExternalStorageDirectory().then((value) {
    //   appDir = value.parent.parent.parent.parent;
    //   Directory appDirectory = Directory("${appDir.path}/YoutubeMusicRecords/");
    // appDir = appDirectory;
    //   appDir.list().listen((onData) {
    //     records.add(onData.path);
    //   }).onDone(() {
    //     records = records.reversed.toList();
    //     _recordProvider.getRecords();
    //   });
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
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
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: buildSongList(),
            ),
            BottomPlayingIndicator(
              isMusic: false,
            )
          ],
        ),
      ),
    );
  }

  Widget buildSongList() {
    return Consumer<RecordProvider>(builder: (_, _provider, __) {
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
              GestureDetector(
                onLongPress: () {
                  showOptions(record);
                },
                onTap: () async {
                  _recordProvider.records = recordList;
                  _recordProvider.setCurrentIndex(index);
                  PageRouter.gotoWidget(
                      RecordedScreen(
                        record: record,
                      ),
                      context);
                },
                child: ListTile(
                  leading: SizedBox(
                      width: 95,
                      height: 150,
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://www.techjockey.com/blog/wp-content/uploads/2019/09/Best-Call-Recording-Apps_feature.png",
                        placeholder: (context, index) => Container(
                          child: Center(
                              child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator())),
                        ),
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.error),
                      )),
                  title: TextViewWidget(
                    text: record.name,
                    color: AppColor.white,
                    textSize: 15,
                    fontFamily: 'Roboto-Regular',
                  ),
                  trailing: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      AppAssets.play,
                      color: AppColor.white,
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
            )),
      );
    });
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
