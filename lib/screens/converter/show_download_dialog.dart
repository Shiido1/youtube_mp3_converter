import 'package:flutter/material.dart';
import 'package:mp3_music_converter/database/repository/song_repository.dart';
import 'package:mp3_music_converter/screens/song/provider/music_provider.dart';
import 'package:mp3_music_converter/screens/split/provider/split_song_provider.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:provider/provider.dart';

Future<String> showDownloadDialog(
    {@required BuildContext context,
    String song,
    String artist,
    String fileName,
    bool download = true,
    bool showAll,
    bool split = true}) {
  TextEditingController songController =
      TextEditingController(text: song ?? '');
  TextEditingController artistController =
      TextEditingController(text: artist ?? '');
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            artistController.addListener(() {
              setState(() {});
            });
            songController.addListener(() {
              setState(() {});
            });
            return Dialog(
              backgroundColor: Color.fromRGBO(40, 40, 40, 1),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Theme(
                  data: Theme.of(context).copyWith(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rename Song',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          autofocus: true,
                          cursorHeight: 20,
                          controller: songController,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: 'Song name',
                            hintStyle: TextStyle(color: Colors.white70),
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2)),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          autofocus: true,
                          cursorHeight: 20,
                          controller: artistController,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: 'Artist name',
                            hintStyle: TextStyle(color: Colors.white70),
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2)),
                          ),
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context, null);
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
                              onTap: artistController.text.trim().length > 0 &&
                                      songController.text.trim().length > 0
                                  ? () async {
                                      if (download)
                                        Navigator.pop(context,
                                            '${songController.text.trim()}+${artistController.text.trim()}');
                                      else {
                                        if (split) {
                                          await SplitSongRepository.renameSong(
                                              fileName: fileName,
                                              artistName:
                                                  artistController.text.trim(),
                                              songName:
                                                  songController.text.trim());
                                          showToast(context,
                                              message:
                                                  'Song renamed successfully');
                                          Provider.of<SplitSongProvider>(
                                                  context,
                                                  listen: false)
                                              .getSongs(showAll);
                                        } else {
                                          await SongRepository.renameSong(
                                              fileName: fileName,
                                              artistName:
                                                  artistController.text.trim(),
                                              songName:
                                                  songController.text.trim());
                                          showToast(context,
                                              message:
                                                  'Song renamed successfully');
                                          Provider.of<MusicProvider>(context,
                                                  listen: false)
                                              .getSongs();
                                        }
                                        Navigator.pop(context);
                                      }
                                    }
                                  : null,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'DONE',
                                  style: TextStyle(
                                      color:
                                          artistController.text.trim().length >
                                                      0 &&
                                                  songController.text
                                                          .trim()
                                                          .length >
                                                      0
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
              ),
            );
          },
        );
      });
}
