import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';

class ShowImage extends StatefulWidget {
  final String name;
  final String photoUrl;
  final bool showSave;
  final String heroKey;
  final bool network;
  ShowImage(
      {Key key,
      @required this.name,
      @required this.photoUrl,
      @required this.heroKey,
      this.showSave = false,
      this.network = false})
      : super(key: key);

  @override
  _ShowImageState createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  downloadImage() async {
    await ImageDownloader.downloadImage(widget.photoUrl,
        destination: AndroidDestinationType.directoryPictures
          ..subDirectory(widget.name));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        toolbarHeight: 70,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: AppColor.bottomRed,
          ),
        ),
        actions: [
          if (widget.showSave)
            IconButton(
                icon: Icon(
                  Icons.save_outlined,
                  color: AppColor.white,
                ),
                onPressed: () {
                  downloadImage();
                })
        ],
        title: Text(
          widget.name,
        ),
        backgroundColor: AppColor.black,
      ),
      body: Center(
        child: Hero(
          tag: widget.heroKey,
          child: widget.network
              ? CachedNetworkImage(
                  imageUrl: widget.photoUrl,
                  progressIndicatorBuilder: (context, value, progress) {
                    return Stack(children: [
                      Container(
                        child: Image.asset('assets/youtubeaudiologo.png'),
                      ),
                      Container(
                        color: Colors.white.withOpacity(0.98),
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.blue),
                            value: progress.progress ?? 0),
                      ),
                    ]);
                  },
                  errorWidget: (context, _, __) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          child: Image.asset('assets/youtubeaudiologo.png'),
                        ),
                        Container(
                          color: Colors.white.withOpacity(0.95),
                        ),
                      ],
                    );
                  })
              : Image.file(File(widget.photoUrl), fit: BoxFit.cover),
        ),
      ),
    );
  }
}
