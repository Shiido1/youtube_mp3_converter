import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:provider/provider.dart';
import 'package:mp3_music_converter/widgets/red_background_backend/provider.dart';
import 'package:mp3_music_converter/widgets/red_background_backend/cloud_storage.dart';

class RedBackground extends StatefulWidget {
  final String text;
  final IconButton iconButton;
  final VoidCallback callback;
  final Widget widgetContainer;

  RedBackground(
      {this.text, this.iconButton, this.callback, this.widgetContainer});

  @override
  _RedBackgroundState createState() => _RedBackgroundState();
}

class _RedBackgroundState extends State<RedBackground> {
  String url;
  // SpeechRecognition speech = SpeechRecognition();

  Future getImage(BuildContext context, bool isCamera) async {
    if (isCamera) {
      var picture = await ImagePicker().getImage(source: ImageSource.camera);
      if (picture != null && picture.path.isNotEmpty && picture.path != null) {
        File image = File(picture.path);
        CloudStorage().imageUploadAndDownload(image: image, context: context);
      }
    } else {
      var picture = await ImagePicker().getImage(source: ImageSource.gallery);
      if (picture != null && picture.path.isNotEmpty && picture.path != null) {
        File image = File(picture.path);
        CloudStorage().imageUploadAndDownload(image: image, context: context);
      }
    }
  }

  Future<void> _showDialog(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 8, 8),
                      child: TextViewWidget(
                        text: 'Camera',
                        color: AppColor.black,
                        textSize: 18,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      getImage(parentContext, true);
                    },
                  ),
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 8, 8, 0),
                      child: TextViewWidget(
                        text: 'Gallery',
                        color: AppColor.black,
                        textSize: 18,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      getImage(parentContext, false);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    Provider.of<RedBackgroundProvider>(context, listen: false).getUrl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    url = Provider.of<RedBackgroundProvider>(context).url;
    return Container(
      child: Stack(
        children: [
          Image.asset(
            AppAssets.background,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fitWidth,
          ),
          Container(
            margin: const EdgeInsets.only(left: 16, right: 16, top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    widget.iconButton != null
                        ? IconButton(
                            icon: widget.iconButton, onPressed: widget.callback)
                        : TextViewWidget(text: '', color: AppColor.transparent),
                    widget.text != null
                        ? TextViewWidget(
                            color: AppColor.white,
                            text: widget.text,
                            textSize: 22,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Montserrat')
                        : Image.asset(
                            AppAssets.dashlogo,
                            height: 63,
                          ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _widgetContainer(url),
                    SizedBox(height: 20),
                    IconButton(
                        icon: Icon(Icons.mic, size: 35, color: AppColor.white),
                        onPressed: () {
                          print('i have been pressed');
                        })
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _widgetContainer(String picUrl) => InkWell(
        onTap: () async {
          await _showDialog(context);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            picUrl == null || picUrl == ''
                ? ClipOval(
                    child: SizedBox(
                        height: 50,
                        width: 50,
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                          placeholder: (context, url) =>
                              new CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              new Icon(Icons.error),
                        )),
                  )
                : ClipOval(
                    child: SizedBox(
                      width: 65,
                      height: 65,
                      child: CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.cover,
                        placeholder: (context, index) => Container(
                          color: Colors.white,
                          child: Center(
                              child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: CircularProgressIndicator())),
                        ),
                        errorWidget: (context, url, error) => Icon(
                          Icons.person,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                'Profile',
                style: TextStyle(
                    fontSize: 17,
                    color: AppColor.white,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Montserrat-Thin'),
              ),
            ),
          ],
        ),
      );
}
