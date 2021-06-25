import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/database/repository/song_repository.dart';
import 'package:mp3_music_converter/screens/recorded/provider/record_provider.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/page_router/navigator.dart';
import 'package:mp3_music_converter/screens/recorded/recorder_services.dart';
import 'package:provider/provider.dart';

Future<Widget> createPlayListScreen(
    {BuildContext context,
    String songName,
    @required bool showToastMessage,
    bool renameRecord = false,
    bool renamePlayList = false,
    String oldPlayListName,
    String message = 'Song added'}) {
  List songs = [];
  songs.add(songName);
  bool showOkButton = false;
  String playListName = '';
  return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Color.fromRGBO(40, 40, 40, 1),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Theme(
                  data: Theme.of(context).copyWith(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        renamePlayList
                            ? 'Rename playlist'
                            : renameRecord
                                ? 'Rename Recording'
                                : 'Name of playlist',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        autofocus: true,
                        cursorHeight: 20,
                        onChanged: (val) {
                          playListName = val.trim();
                          setState(() {
                            showOkButton = val.trim().length > 0 ? true : false;
                          });
                        },

                        style: TextStyle(color: Colors.white, fontSize: 16),
                        // cursorColor: Color.fromARGB(1, 216, 19, 37),
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: renamePlayList
                              ? 'Rename playlist'
                              : renameRecord
                                  ? 'Rename record'
                                  : 'Name of playlist',
                          hintStyle: TextStyle(color: Colors.white70),
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              PageRouter.goBack(context);
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: Text('CANCEL',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                            ),
                          ),
                          InkWell(
                            onTap: showOkButton
                                ? () async {
                                    renamePlayList
                                        ? await SongRepository.renamePlayList(
                                            newName: playListName,
                                            oldName: oldPlayListName)
                                        : renameRecord
                                            ? await RecorderServices()
                                                .renameRecording(
                                                    oldName: oldPlayListName,
                                                    newName: playListName)
                                            : await SongRepository
                                                .createPlayList(
                                                    playListName, songs);
                                    showToastMessage
                                        ? PageRouter.goBack(context)
                                        : Navigator.pop(
                                            context, Text(playListName));
                                    if (showToastMessage)
                                      showToast(context, message: message);
                                    if (renameRecord)
                                      Provider.of<RecordProvider>(context,
                                              listen: false)
                                          .getRecords();
                                    // SongServices().createPlayList(playListName: playListName, songName: songs);
                                  }
                                : null,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'OK',
                                style: TextStyle(
                                    color: showOkButton
                                        ? Colors.blue
                                        : Colors.blue.withOpacity(0.5),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      });
}
