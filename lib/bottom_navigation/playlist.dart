import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/screens/dashboard/main_dashboard.dart';
import 'package:mp3_music_converter/screens/playlist/database/model/playlist_log.dart';
import 'package:mp3_music_converter/screens/playlist/database/repo/playlist_log_repo.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/widgets/bottom_playlist_indicator.dart';
import 'package:mp3_music_converter/widgets/red_background.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';

class PlayList extends StatefulWidget {
  @override
  _PlayListState createState() => _PlayListState();
}

class _PlayListState extends State<PlayList> {
  // int _currentIndex = 0;
  String mp3;

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
              child: FutureBuilder(
            future: PlayListLogRepository.getLogs(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: null,
                );
              }
              if (snapshot.hasData) {
                List<dynamic> logList = snapshot.data;
                if (logList.isNotEmpty) {
                  return ListView.builder(
                    itemCount: logList.length,
                    itemBuilder: (BuildContext context, int index) {
                      PlayListLog _log = logList[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: SizedBox(
                                width: 95,
                                height: 150,
                                child: _log?.image != null &&
                                        _log.image.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: _log.image,
                                        placeholder: (context, index) =>
                                            Container(
                                          child: Center(
                                              child: SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator())),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            new Icon(Icons.error),
                                      )
                                    : null),
                            title: InkWell(
                              onTap: () async {
                                File tempFile =
                                    File('${_log?.filePath}/${_log?.fileName}');
                                mp3 = tempFile.uri.toString();
                                // setState(() {
                                //   _filepath = _log?.filePath;
                                //   _filename = _log?.fileName;
                                //   _imageFile = _log?.image;
                                //   _tpFile = mp3;
                                // });
                                // _musicProvider.musicdata = PlayListLog(
                                //     filePath: _filepath,
                                //     fileName: _filename,
                                //     image: _imageFile,
                                //     file: _tpFile);
                                // preferencesHelper.saveValue(
                                //     key: 'last_play',
                                //     value: json
                                //         .encode(_musicProvider.musicdata.toJson()));
                                // PageRouter.gotoWidget(
                                //     SongViewScreen(_imageFile, _filename, _tpFile),
                                //     context);
                              },
                              child: TextViewWidget(
                                text: _log?.fileName ?? '',
                                color: AppColor.white,
                                textSize: 15,
                                fontFamily: 'Roboto-Regular',
                              ),
                            ),
                            trailing: Icon(
                              Icons.navigate_next_sharp,
                              color: AppColor.white,
                            ),
                            onTap: () {
                              print(
                                  'to play this video use this: ${_log?.filePath}/${_log?.fileName}');
                            },
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 115.0, right: 15),
                            child: Divider(
                              color: AppColor.white,
                            ),
                          )
                        ],
                      );
                    },
                  );
                }
                return Center(
                    child:
                        TextViewWidget(text: 'No Song', color: AppColor.white));
              }
              return Center(child: Text('No Music Files.'));
            },
          )),
          BottomPlayingIndicator()
        ],
      ),
    );
  }
}
