import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/widgets/progress_indicator.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:http/http.dart' as http;

enum whatToCreate { Folders, SubFolders }

class FolderList extends StatefulWidget {
  FolderList({Key key}) : super(key: key);

  @override
  _FolderListState createState() => _FolderListState();
}

class _FolderListState extends State<FolderList> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawerEnableOpenDragGesture: false,
      backgroundColor: AppColor.white.withOpacity(0.05),
      appBar: AppBar(
        backgroundColor: AppColor.black,
        title: TextViewWidget(
          text: 'Folders',
          color: AppColor.bottomRed,
        ),
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
          createFolderOrSubfolder(
              toCreate: whatToCreate.Folders,
              title: 'Noname',
              context: context),
        ],
        // bottom: PreferredSize(
        //     child: Align(
        //         alignment: Alignment.centerLeft,
        //         child: Text('Niza is a friend',
        //             style: TextStyle(color: Colors.blue))),
        //     preferredSize: Size.fromHeight(10)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Column(
              children: [
                MaterialButton(
                  onPressed: () {
                    // Navigator.push(
                    //     context, MaterialPageRoute(builder: (_) => CreateBook()));
                  },
                  color: Colors.white12,
                  height: 60,
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.solidFolder,
                        size: 30,
                        color: Colors.white,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Folder $index',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
              ],
            );
          },
          itemCount: 6,
        ),
      ),
    );
  }
}

Widget createFolderOrSubfolder(
    {@required whatToCreate toCreate,
    @required BuildContext context,
    @required String title}) {
  showTitleInputField() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return TitleInputField(toCreate);
        });
  }

  return GestureDetector(
    onTap: () {
      showTitleInputField();
    },
    child: Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      height: 35,
      width: 35,
      child: Icon(
        Icons.add,
        color: Colors.white,
        size: 30,
      ),
    ),
  );
}

class TitleInputField extends StatefulWidget {
  final whatToCreate toCreate;
  TitleInputField(this.toCreate);

  @override
  _TitleInputFieldState createState() => _TitleInputFieldState();
}

class _TitleInputFieldState extends State<TitleInputField> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _textEditingController;
  CustomProgressIndicator _progressIndicator;
  String token;
  bool showError = false;
  String error = '';

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _progressIndicator = CustomProgressIndicator(context);
    getData();
    super.initState();
  }

  getData() async {
    token = await preferencesHelper.getStringValues(key: 'token');
  }

  createFolder({@required String title, @required String token}) async {
    String url = "https://youtubeaudio.com/api/book/createfolder";

    _progressIndicator.show();
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'title': title, 'token': token}));
    _progressIndicator.dismiss();

    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      if (data['message'].toString().toLowerCase().contains('created')) {
        showToast(context,
            message: 'Folder created',
            backgroundColor: Colors.green,
            gravity: 1);
        Navigator.pop(context);
      } else
        setState(() {
          error = data['message'].toString();
          showError = true;
        });
    } else {
      try {
        Map data = jsonDecode(response.body);
        setState(() {
          error = data['message'].toString();
          showError = true;
        });
      } catch (e) {
        setState(() {
          error = 'An error occurred';
          showError = true;
        });
      }
    }
  }

  createSubfolder() async {}

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.toCreate == whatToCreate.Folders
                    ? 'Folder name'
                    : 'Subfolder name',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              SizedBox(height: 10),
              Form(
                key: _formKey,
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: widget.toCreate == whatToCreate.Folders
                        ? 'Name of folder'
                        : 'Name of subfolder',
                    hintStyle: TextStyle(color: Colors.black38),
                  ),
                  controller: _textEditingController,
                  textCapitalization: TextCapitalization.words,
                  validator: (val) {
                    return val.trim().isEmpty ? 'Please enter a name' : null;
                  },
                ),
              ),
              if (showError) SizedBox(height: 10),
              if (showError)
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 15),
                ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    color: Colors.red,
                    elevation: 0,
                  ),
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        showError = false;
                      });
                      widget.toCreate == whatToCreate.Folders
                          ? createFolder(
                              title: _textEditingController.text, token: token)
                          : createSubfolder();
                    },
                    child: Text(
                      'Create',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    color: Colors.blue,
                    elevation: 0,
                  ),
                ],
              )
            ]),
      ),
    );
  }
}
