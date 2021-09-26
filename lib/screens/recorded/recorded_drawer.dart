import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mp3_music_converter/database/model/song.dart';
import 'package:mp3_music_converter/playlist/create_playlist_screen.dart';
import 'package:mp3_music_converter/screens/recorded/model/recorder_model.dart';
import 'package:mp3_music_converter/screens/recorded/provider/equalizer.dart';
import 'package:mp3_music_converter/screens/recorded/provider/record_provider.dart';
import 'package:mp3_music_converter/screens/recorded/public_share.dart';
import 'package:mp3_music_converter/screens/song/upload_song.dart';
import 'package:mp3_music_converter/screens/split/delete_song.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/utils/page_router/navigator.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class RecordedDrawer extends StatefulWidget {
  final RecorderModel model;

  RecordedDrawer({@required this.model});

  @override
  _RecordedDrawerState createState() => _RecordedDrawerState();
}

class _RecordedDrawerState extends State<RecordedDrawer> {
  String token;
  int id;

  @override
  void initState() {
    Provider.of<RecordProvider>(context, listen: false).drawerRecord =
        widget.model;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: Drawer(
        child: Container(
          decoration: BoxDecoration(color: AppColor.black.withOpacity(0.9)),
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
                            child: Image.asset(
                              'assets/log.png',
                            ),
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
                          buildShareOptions(
                            context,
                            model: widget.model,
                          );
                        },
                        leading: Icon(
                          Icons.share,
                          color: AppColor.white,
                        ),
                        title: TextViewWidget(
                          text: 'Share Recording',
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
                  Wrap(
                    children: [
                      Divider(color: AppColor.white),
                      ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => Equalizer()));
                        },
                        title: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: TextViewWidget(
                            text: 'Equalizer',
                            color: AppColor.white,
                            textSize: 18,
                          ),
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

showRecorderPrivateShareDialog(BuildContext context, int libid) async {
  TextEditingController emailController = TextEditingController();
  String token = await preferencesHelper.getStringValues(key: 'token');
  final _formKey = GlobalKey<FormState>();

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
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          autofocus: true,
                          cursorHeight: 20,
                          controller: emailController,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          textCapitalization: TextCapitalization.words,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (val) {
                            return !validateEmail(val.trim())
                                ? 'Please enter a valid email'
                                : null;
                          },
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Colors.white70),
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2)),
                          ),
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
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  privateShareSong(
                                      token: token,
                                      email: emailController.text,
                                      id: libid,
                                      context: context);
                                }
                              },
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

showPrivateShareDialog(BuildContext context, Song song) async {
  TextEditingController emailController = TextEditingController();
  String token = await preferencesHelper.getStringValues(key: 'token');
  final _formKey = GlobalKey<FormState>();

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
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          autofocus: true,
                          cursorHeight: 20,
                          controller: emailController,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          textCapitalization: TextCapitalization.words,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (val) {
                            return !validateEmail(val.trim())
                                ? 'Please enter a valid email'
                                : null;
                          },
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Colors.white70),
                            enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2)),
                          ),
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
                              onPressed: () {
                                if (_formKey.currentState.validate())
                                  privateShareSong(
                                      token: token,
                                      email: emailController.text,
                                      id: song.libid,
                                      context: context);
                                if (song.vocalLibid != null)
                                  privateShareSong(
                                      token: token,
                                      email: emailController.text,
                                      id: song.vocalLibid,
                                      context: context);
                              },
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

privateShareSong(
    {@required String token,
    @required String email,
    @required int id,
    @required BuildContext context}) async {
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

      if (decodedResponse['message'].toString().toLowerCase().trim() ==
          'transfer went sucess!')
        showToast(context,
            message: 'Song successfully shared!',
            backgroundColor: Colors.white,
            textColor: Colors.black);
      else
        showToast(context,
            message: 'Failed to share song. Try again later',
            backgroundColor: Colors.white,
            textColor: Colors.black);
    } else
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pop(context);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pop(context);
  }
}

Future<Widget> buildShareOptions(BuildContext context, {RecorderModel model}) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromRGBO(40, 40, 40, 1),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () {
                  if (model.libid == null || model.musicid == null)
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UploadSong(true, model: model, isPrivate: true),
                      ),
                    );
                  else {
                    Navigator.pop(context);
                    showRecorderPrivateShareDialog(context, model.libid);
                  }
                },
                child: Text(
                  'Private share',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              Divider(
                color: Colors.white,
              ),
              TextButton(
                onPressed: () {
                  if (model.libid == null || model.musicid == null)
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UploadSong(true, model: model),
                      ),
                    );
                  else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PublicShare(model.libid),
                      ),
                    );
                  }
                },
                child: Text(
                  'Public share',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              // Divider(
              //   color: Colors.white,
              // ),
              // TextButton(
              //   onPressed: () async {
              //     Share.shareFiles([File(model.path).path]);
              //     PageRouter.goBack(context);
              //   },
              //   child: Text(
              //     'Share to other apps',
              //     style: TextStyle(color: Colors.white, fontSize: 18),
              //   ),
              // ),
            ],
          ),
        );
      },);
}
