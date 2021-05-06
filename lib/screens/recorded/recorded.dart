import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mp3_music_converter/screens/recorded/provider/record_provider.dart';
import 'package:mp3_music_converter/screens/recorded/recorded_screen.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/page_router/navigator.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/bottom_playlist_indicator.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';


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

    records = [];
    _recordProvider = Provider.of<RecordProvider>(context, listen: false);
    getExternalStorageDirectory().then((value) {
      appDir = value.parent.parent.parent.parent;
      Directory appDirectory = Directory("${appDir.path}/YoutubeMusicRecords/");
      appDir = appDirectory;
      appDir.list().listen((onData) {
        records.add(onData.path);
      }).onDone(() {
        records = records.reversed.toList();
        _recordProvider.getRecords(records);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    appDir = null;
    records = null;
    super.dispose();
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
            Expanded(child: buildSongList(),

            ),
            BottomPlayingIndicator(isMusic: false,)
          ],
        ),
      ),
    );
  }

  Widget buildSongList() {
    return Consumer<RecordProvider>(builder: (_, _provider, __) {
      if (records.length < 1) {
        return Center(
            child: TextViewWidget(text: 'No Recorded Song', color: AppColor.white));
      }
      return ListView.separated(
        itemCount: records.length,
        itemBuilder: (_, int index){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async{
                  _recordProvider.records = _recordProvider.allRecords;
                  _recordProvider.setCurrentIndex(index);
                  PageRouter.gotoWidget(RecordedScreen(record: records[index], recordName: "Record ${records.length - index}",), context);},
                child: ListTile(
                  leading: SizedBox(
                      width: 95,
                      height: 150,
                      child: CachedNetworkImage(
                        imageUrl: "https://www.techjockey.com/blog/wp-content/uploads/2019/09/Best-Call-Recording-Apps_feature.png",
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
                  ),
                  title: TextViewWidget(
                    text: "Record ${records.length - index}",
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
        separatorBuilder: (_, int index) =>  Padding(
            padding: const EdgeInsets.only(left: 115.0, right: 15),
            child: Divider(
              color: AppColor.white,
            )),
      );
    });


  }
}
