import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/database/model/log.dart';
import 'package:mp3_music_converter/database/repository/log_repository.dart';
import 'package:mp3_music_converter/screens/song/provider/music_provider.dart';
import 'package:mp3_music_converter/screens/song/song_view.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/utils/helper/pref_manager.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:provider/provider.dart';

class ImageFile extends StatefulWidget {
  @override
  _ImageFileState createState() => _ImageFileState();
}

class _ImageFileState extends State<ImageFile> {
  String imagefile;
  MusicProvider _musicProvider;

  @override
  void initState() {
    super.initState();
    _musicProvider = Provider.of<MusicProvider>(context, listen: false);
  }

  // prefMed() {
  //   preferencesHelper
  //       .getStringValues(key: 'image')
  //       .then((value) => setState(() {
  //             imagefile = value;
  //           }));
  // }

  @override
  Widget build(BuildContext context) {
    // prefMed();
    return _musicProvider?.musicdata?.image?.isNotEmpty ?? false
        ? Padding(
            padding: const EdgeInsets.all(5.0),
            child: CachedNetworkImage(
              imageUrl: _musicProvider?.musicdata?.image,
              fit: BoxFit.fitHeight,
            ),
          )
        : Container();
  }
}
