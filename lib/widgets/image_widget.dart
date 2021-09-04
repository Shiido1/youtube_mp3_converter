import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/screens/song/provider/music_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    return _musicProvider?.currentSong?.image?.isNotEmpty ?? false
        ? Padding(
            padding: const EdgeInsets.all(5.0),
            child: CachedNetworkImage(
              imageUrl: _musicProvider?.currentSong?.image ?? '',
              fit: BoxFit.fitHeight,
              errorWidget: (context, data, _) => Container(
                  color: Colors.white54, child: Icon(Icons.error, size: 40)),
            ),
          )
        : Container();
  }
}
