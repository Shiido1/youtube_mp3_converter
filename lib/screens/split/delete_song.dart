import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/database/repository/song_repository.dart';
import 'package:mp3_music_converter/screens/converter/show_download_dialog.dart';
import 'package:mp3_music_converter/screens/recorded/model/recorder_model.dart';
import 'package:mp3_music_converter/screens/recorded/provider/record_provider.dart';
import 'package:mp3_music_converter/screens/recorded/recorder_services.dart';
import 'package:mp3_music_converter/screens/song/provider/music_provider.dart';
import 'package:mp3_music_converter/screens/split/provider/split_song_provider.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class DeleteSongs {
  BuildContext context;
  DeleteSongs(this.context);

  Future<void> showDeleteDialog(
      {Song song,
      RecorderModel record,
      bool split = false,
      bool showAll = false}) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Color.fromRGBO(40, 40, 40, 1),
            content: Theme(
              data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    showDownloadDialog(
                        song: song.songName,
                        artist: song.artistName,
                        context: context,
                        fileName: song.splitFileName,
                        download: false,
                        showAll: showAll);
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
                        'Rename Song',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    showConfirmDeleteDialog(
                        song: song,
                        record: record,
                        split: split,
                        showAll: showAll);
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 10),
                    height: 50,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(0),
                      leading: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      title: Text(
                        'Delete Song',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          );
        });
  }

  Future<void> showConfirmDeleteDialog(
      {Song song, RecorderModel record, bool split = false, bool showAll}) {
    bool removeFromLib = false;
    return showDialog(
        context: context,
        builder: (_) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Color.fromRGBO(40, 40, 40, 1),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Are you sure you want to delete this song?',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  if ((song?.musicId != null && song.musicId.isNotEmpty) ||
                      (record?.musicid != null && record.musicid.isNotEmpty))
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      alignment: Alignment.centerLeft,
                      child: Theme(
                        data: Theme.of(context).copyWith(
                            unselectedWidgetColor: Colors.white,
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent),
                        child: CheckboxListTile(
                          value: removeFromLib,
                          onChanged: (val) {
                            setState(() {
                              removeFromLib = val;
                            });
                          },
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(
                            'Remove from library?',
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
                  child: Text('No',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  onPressed: () {
                    Navigator.pop(_);
                  },
                ),
                TextButton(
                  child: Text('Yes',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  onPressed: () {
                    deleteSong(
                        song: song,
                        record: record,
                        context: _,
                        split: split,
                        showAll: showAll,
                        removeFromLib: removeFromLib);
                  },
                ),
              ],
            );
          });
        });
  }
}

Future<void> deleteSong(
    {Song song,
    RecorderModel record,
    @required BuildContext context,
    @required bool split,
    bool showAll,
    bool removeFromLib = false}) async {
  String token = await preferencesHelper.getStringValues(key: 'token');

  if (removeFromLib) {
    try {
      var response = await http.post('https://youtubeaudio.com/api/deletesong',
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'token': token, 'id': record.musicid}));
      print(jsonDecode(response.body));
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['message'].toString().toLowerCase().trim() ==
            'deleted') {
          deleteSong2(
              song: song,
              record: record,
              context: context,
              split: split,
              showAll: showAll);
        } else if (responseData['message'].toString().toLowerCase().trim() ==
            'song not found')
          showToast(context, message: 'Song not found in library');
        else
          showToast(context,
              message: 'Failed to delete song from library. Try again');
      } else
        showToast(context,
            message: 'Failed to delete song from library. Try again');
    } catch (e) {
      showToast(context,
          message:
              'Failed to delete song from library. Please check your internet connection and try again.');
    }
  } else {
    deleteSong2(
        song: song,
        record: record,
        context: context,
        split: split,
        showAll: showAll);
  }
}

Future<void> deleteSong2(
    {@required Song song,
    @required RecorderModel record,
    @required BuildContext context,
    @required bool split,
    @required bool showAll}) async {
  if (song != null) {
    var path = song.file.split('/');
    int index = path.indexOf(
        path.firstWhere((element) => element != '' && element != 'file:'));
    path.removeRange(0, index);
    var file = File(Uri.decodeFull(path.join('/')));

    if (song?.vocalName?.split('-')?.last == 'vocals.wav' ?? false) {
      var path2 = song.vocalName.split('/');
      int index = path2.indexOf(
          path2.firstWhere((element) => element != '' && element != 'file:'));
      path2.removeRange(0, index);

      path.removeLast();
      File file2 = File(Uri.decodeFull('${path.join('/')}/${path2.join('/')}'));

      try {
        await file2.delete();
      } catch (_) {
        print(_);
      }
    }
    try {
      await file.delete();
      if (!split) {
        SongRepository.deleteSong(song.fileName);
        Provider.of<MusicProvider>(context, listen: false).getSongs();
        SongRepository.removeSongsFromPlaylistAterDelete(song.fileName);
        Navigator.pop(context);
      }
      if (split) {
        SplitSongRepository.deleteSong(song.splitFileName);
        Provider.of<SplitSongProvider>(context, listen: false)
            .getSongs(showAll);
        Navigator.pop(context);
      }
    } catch (_) {
      showToast(context, message: 'Failed to delete song');
    }
  }
  if (record != null) {
    var path = record.path.split('/');
    path.removeAt(0);
    var file = File(path.join('/'));
    try {
      await file.delete();
      RecorderServices().deleteRecording(record.name);
      Provider.of<RecordProvider>(context, listen: false).getRecords();
      Navigator.pop(context);
    } catch (_) {
      print(_);
      RecorderServices().deleteRecording(record.name);
      Provider.of<RecordProvider>(context, listen: false).getRecords();
      Navigator.pop(context);
    }
  }
}
