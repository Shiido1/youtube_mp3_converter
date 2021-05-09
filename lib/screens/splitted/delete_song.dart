import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/database/repository/song_repository.dart';
import 'package:mp3_music_converter/screens/recorded/model/recorder_model.dart';
import 'package:mp3_music_converter/screens/recorded/provider/record_provider.dart';
import 'package:mp3_music_converter/screens/recorded/recorder_services.dart';
import 'package:mp3_music_converter/screens/song/provider/music_provider.dart';
import 'package:provider/provider.dart';

class DeleteSongs {
  BuildContext context;
  DeleteSongs(this.context);

  Future<void> showDeleteDialog({Song song, RecorderModel record}) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Color.fromRGBO(40, 40, 40, 1),
            content: Theme(
              data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  showConfirmDeleteDialog(song: song, record: record);
                },
                child: Container(
                  height: 30,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Delete Song',
                    style: TextStyle(fontSize: 17, color: Colors.white),
                  ),
                ),
              ),
            ),
          );
        });
  }

  Future<void> showConfirmDeleteDialog({Song song, RecorderModel record}) {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            backgroundColor: Color.fromRGBO(40, 40, 40, 1),
            content: Text(
              'Are you sure you want to delete this song?',
              style: TextStyle(color: Colors.white, fontSize: 17),
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
                  deleteSong(song: song, record: record, context: _);
                },
              ),
            ],
          );
        });
  }
}

Future<void> deleteSong(
    {Song song, RecorderModel record, @required BuildContext context}) async {
  if (song != null) {
    var path = song.file.split('/');
    path.removeRange(0, 3);
    var file = File(path.join('/'));
    try {
      await file.delete();
      SongRepository.deleteSong(song.fileName);
      SongRepository.removeSongsFromPlaylistAterDelete(song.fileName);
      Navigator.pop(context);
    } catch (_) {
      print('couldn\'t delete');
      SongRepository.deleteSong(song.fileName);
      Provider.of<MusicProvider>(context, listen: false).getSongs();
      SongRepository.removeSongsFromPlaylistAterDelete(song.fileName);
      Navigator.pop(context);
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
      Provider.of<RecorderServices>(context).getRecordings();
      Navigator.pop(context);
    }
  }
}
