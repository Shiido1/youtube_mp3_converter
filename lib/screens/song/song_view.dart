import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mp3_music_converter/database/model/log.dart';
import 'package:mp3_music_converter/database/repository/log_repository.dart';
import 'package:mp3_music_converter/screens/song/song_view_screen.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/screens/song/provider/music_provider.dart';
import 'package:mp3_music_converter/utils/page_router/navigator.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/bottom_playlist_indicator.dart';
import 'package:mp3_music_converter/widgets/drawer.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SongViewCLass extends StatefulWidget {
  // String file;

  @override
  _SongViewCLassState createState() => _SongViewCLassState();
}

class _SongViewCLassState extends State<SongViewCLass> {
  String _filename, _flname;
  String _imageFile, _img;
  String _filepath;
  String _tpFile;
  MusicProvider _musicProvider;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  String mp3 = '';

  @override
  void initState() {
    _musicProvider = Provider.of<MusicProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.black,
        title: TextViewWidget(
          text: 'Song',
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
      endDrawer: Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
          child: AppDrawer()),
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
    return FutureBuilder(
      future: LogRepository.getLogs(),
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
                Log _log = logList[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: SizedBox(
                          width: 95,
                          height: 150,
                          child: _log?.image != null && _log.image.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: _log.image,
                                  placeholder: (context, index) => Container(
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
                          setState(() {
                            _filepath = _log?.filePath;
                            _filename = _log?.fileName;
                            _imageFile = _log?.image;
                            _tpFile = mp3;
                          });
                          _musicProvider.musicdata = Log(
                              filePath: _filepath,
                              fileName: _filename,
                              image: _imageFile,
                              file: _tpFile);
                          preferencesHelper.saveValue(
                              key: 'last_play',
                              value: json
                                  .encode(_musicProvider.musicdata.toJson()));
                          PageRouter.gotoWidget(
                              SongViewScreen(_imageFile, _filename, _tpFile),
                              context);
                        },
                        child: TextViewWidget(
                          text: _log?.fileName ?? '',
                          color: AppColor.white,
                          textSize: 15,
                          fontFamily: 'Roboto-Regular',
                        ),
                      ),
                      trailing: InkWell(
                        onTap: () {
                          _musicProvider.updateDrawer(_log);
                          _scaffoldKey.currentState.openEndDrawer();
                        },
                        child: SvgPicture.asset(
                          AppAssets.dot,
                          color: AppColor.white,
                        ),
                      ),
                      onTap: () {
                        print(
                            'to play this video use this: ${_log?.filePath}/${_log?.fileName}');
                      },
                    ),
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
          }
          return Center(
              child: TextViewWidget(text: 'No Song', color: AppColor.white));
        }
        return Center(child: Text('No Music Files.'));
      },
    );
  }
}
