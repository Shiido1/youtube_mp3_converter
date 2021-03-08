import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/database/repository/log_repository.dart';
import 'package:mp3_music_converter/screens/song/song_view.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/utils/helper/pref_manager.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';

class ImageFile extends StatefulWidget {
  SharedPreferencesHelper sharedPreferencesHelper;

  @override
  _ImageFileState createState() => _ImageFileState();
}

class _ImageFileState extends State<ImageFile> {
  String imagefile;
  @override
  void initState() {
    // TODO: implement initState
    prefMed();
    super.initState();
  }

  prefMed() {
    preferencesHelper
        .getStringValues(key: 'image')
        .then((value) => setState(() {
              imagefile = value;
            }));
  }

  @override
  Widget build(BuildContext context) {
    prefMed();
    return imagefile != null && imagefile.isNotEmpty
        ? CachedNetworkImage(
            imageUrl: imagefile,
            fit: BoxFit.fill,
          )
        : Container();
  }
}
