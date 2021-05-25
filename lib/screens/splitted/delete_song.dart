import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/database/repository/song_repository.dart';
import 'package:mp3_music_converter/screens/recorded/model/recorder_model.dart';
import 'package:mp3_music_converter/screens/recorded/provider/record_provider.dart';
import 'package:mp3_music_converter/screens/recorded/recorder_services.dart';
import 'package:mp3_music_converter/screens/song/provider/music_provider.dart';
import 'package:mp3_music_converter/screens/song/provider/music_provider_services.dart';
import 'package:mp3_music_converter/screens/splitted/provider/splitted_song_provider.dart';
import 'package:provider/provider.dart';

class DeleteSongs {
  BuildContext context;
  DeleteSongs(this.context);

  Future<void> showDeleteDialog(
      {Song song,
      RecorderModel record,
      bool splitted = false,
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
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  showConfirmDeleteDialog(
                      song: song,
                      record: record,
                      splitted: splitted,
                      showAll: showAll);
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

  Future<void> showConfirmDeleteDialog(
      {Song song, RecorderModel record, bool splitted = false, bool showAll}) {
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
                  deleteSong(
                      song: song,
                      record: record,
                      context: _,
                      splitted: splitted,
                      showAll: showAll);
                },
              ),
            ],
          );
        });
  }
}

Future<void> deleteSong(
    {Song song,
    RecorderModel record,
    @required BuildContext context,
    @required bool splitted,
    bool showAll}) async {
  if (song != null) {
    var path = song.file.split('/');
    int index = path.indexOf(
        path.firstWhere((element) => element != '' && element != 'file:'));
    path.removeRange(0, index);
    print('this is the path: ${path.join('/')}');
    var file = File(path.join('/'));
    try {
      await file.delete();
      if (!splitted) {
        SongRepository.deleteSong(song.fileName);
        Provider.of<MusicProvider>(context, listen: false).getSongs();
        SongRepository.removeSongsFromPlaylistAterDelete(song.fileName);
        Navigator.pop(context);
      }
      if (splitted) {
        SplittedSongRepository.deleteSong(song.splittedFileName);
        Provider.of<SplittedSongProvider>(context, listen: false)
            .getSongs(showAll);
        Navigator.pop(context);
      }
    } catch (_) {
      print('couldn\'t delete');
      if (!splitted) {
        SongRepository.deleteSong(song.fileName);
        Provider.of<MusicProvider>(context, listen: false).getSongs();
        SongRepository.removeSongsFromPlaylistAterDelete(song.fileName);
        Navigator.pop(context);
      }
      if (splitted) {
        SplittedSongRepository.deleteSong(song.splittedFileName);
        Provider.of<SplittedSongProvider>(context, listen: false)
            .getSongs(showAll);
        Navigator.pop(context);
      }
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
