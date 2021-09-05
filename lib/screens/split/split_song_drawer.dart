import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/screens/converter/show_download_dialog.dart';
import 'package:mp3_music_converter/screens/split/delete_song.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/widgets/drawer.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';

class SplitSongDrawer extends StatefulWidget {
  final Song song;
  final bool showAll;
  SplitSongDrawer(this.song, this.showAll);

  @override
  _SplitSongDrawerState createState() => _SplitSongDrawerState();
}

class _SplitSongDrawerState extends State<SplitSongDrawer> {
  @override
  Widget build(BuildContext context) {
    print(widget.song.libid);
    print(widget.song.vocalLibid);
    print(widget.song.musicid);
    return Container(
      height: 300,
      child: Drawer(
        child: Container(
          decoration: BoxDecoration(color: AppColor.black.withOpacity(0.5)),
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            height: 60,
                            width: 50,
                            margin: EdgeInsets.only(left: 15),
                            child: widget.song.image != null &&
                                    widget.song.image.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: widget.song.image)
                                : Container(
                                    color: Colors.white,
                                    alignment: Alignment.center,
                                    child: Text(
                                      widget.song.songName[0].toUpperCase() ??
                                          'U',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 45,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: TextViewWidget(
                              text: widget.song.songName ?? 'Unknown',
                              color: AppColor.white,
                              textSize: 16.5,
                              fontWeight: FontWeight.w500,
                            ),
                            subtitle: TextViewWidget(
                              text: widget.song.artistName ?? 'Unknown Artist',
                              color: AppColor.white,
                              textSize: 12.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    color: AppColor.white,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      showDownloadDialog(
                          song: widget.song.songName,
                          artist: widget.song.artistName,
                          context: context,
                          fileName: widget.song.splitFileName,
                          download: false,
                          showAll: widget.showAll);
                    },
                    leading: Icon(Icons.edit, color: Colors.white),
                    title: TextViewWidget(
                      text: 'Rename Song',
                      color: AppColor.white,
                      textSize: 18,
                    ),
                  ),
                  Divider(
                    color: AppColor.white,
                  ),
                  Wrap(
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          buildShareOptions(context, song: widget.song);
                        },
                        leading: Icon(
                          Icons.share,
                          color: AppColor.white,
                        ),
                        title: TextViewWidget(
                          text: 'Share Song',
                          color: AppColor.white,
                          textSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Wrap(
                    children: [
                      Divider(color: AppColor.white),
                      ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          DeleteSongs(context).showConfirmDeleteDialog(
                              song: widget.song,
                              split: true,
                              showAll: widget.showAll);
                        },
                        leading: Icon(
                          Icons.delete,
                          color: AppColor.white,
                        ),
                        title: TextViewWidget(
                          text: 'Delete Song',
                          color: AppColor.white,
                          textSize: 18,
                        ),
                      ),
                    ],
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
