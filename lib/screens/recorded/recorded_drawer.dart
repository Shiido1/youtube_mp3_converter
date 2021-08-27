import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mp3_music_converter/playlist/create_playlist_screen.dart';
import 'package:mp3_music_converter/screens/recorded/model/recorder_model.dart';
import 'package:mp3_music_converter/screens/splitted/delete_song.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/constant.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/utils/string_assets/assets.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:http/http.dart' as http;

class RecordedDrawer extends StatefulWidget {
  final RecorderModel model;
  final String url;
  RecordedDrawer({@required this.model, @required this.url});

  @override
  _RecordedDrawerState createState() => _RecordedDrawerState();
}

class _RecordedDrawerState extends State<RecordedDrawer> {
  String token;
  int id;

  getDetails() async {
    token = await preferencesHelper.getStringValues(key: 'token');
    //TODO: complete this function
  }

  privateShareSong(
      {@required String token,
      @required String email,
      @required int id}) async {
    String url = "http://67.205.165.56/api/transferapi";
    final snackBar = SnackBar(
      content: Text('Failed to share song. Try again later'),
      backgroundColor: Colors.red,
    );
    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          'token': token,
          'id': id,
          'email': email,
        }),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        Map decodedResponse = jsonDecode(response.body);
        //TODO: do something with this response

        // if (decodedResponse['message']
        //     .toString()
        //     .toLowerCase()
        //     .contains("successfully")) {
        // ScaffoldMessenger.of(context).showSnackBar(snackBar2);
        // } else
        //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void initState() {
    getDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
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
                            child: CachedNetworkImage(imageUrl: widget.url),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: TextViewWidget(
                              text: widget.model.name,
                              color: AppColor.white,
                              textSize: 16.5,
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
                      createPlayListScreen(
                          showToastMessage: true,
                          message: 'Recording renamed successfully',
                          renameRecord: true,
                          oldPlayListName: widget.model.name,
                          context: context);
                    },
                    leading: Icon(Icons.edit, color: Colors.white),
                    title: TextViewWidget(
                      text: 'Rename Recording',
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
                          showPrivateShareDialog(context);
                        },
                        leading: Icon(
                          Icons.share,
                          color: AppColor.white,
                        ),
                        title: TextViewWidget(
                          text: 'Share Recording (Private)',
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
                        onTap: () {},
                        leading: Icon(
                          Icons.share,
                          color: AppColor.white,
                        ),
                        title: TextViewWidget(
                          text: 'Share Recording (Public)',
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
                          DeleteSongs(context)
                              .showConfirmDeleteDialog(record: widget.model);
                        },
                        leading: Icon(
                          Icons.delete,
                          color: AppColor.white,
                        ),
                        title: TextViewWidget(
                          text: 'Delete Recording',
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

showPrivateShareDialog(BuildContext context) async {
  TextEditingController emailController = TextEditingController();
  String token = await preferencesHelper.getStringValues(key: 'token');
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          emailController.addListener(() {});
          return Dialog(
            backgroundColor: Color.fromRGBO(40, 40, 40, 1),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Theme(
                data: Theme.of(context).copyWith(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enter email to share song',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        autofocus: true,
                        cursorHeight: 20,
                        controller: emailController,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Email',
                          hintStyle: TextStyle(color: Colors.white70),
                          enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 2)),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel',
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 16)),
                            ),
                            SizedBox(width: 40),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Done',
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 17),
                              ),
                            )
                          ]),
                    ]),
              ),
            ),
          );
        });
      });
}
