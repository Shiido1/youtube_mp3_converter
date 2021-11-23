import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mp3_music_converter/screens/bookworm/create_book/choose_folder.dart';
import 'package:mp3_music_converter/screens/bookworm/folders/folder_details.dart';
import 'package:mp3_music_converter/screens/bookworm/folders/folder_options.dart';
import 'package:mp3_music_converter/screens/bookworm/model/model.dart';
import 'package:mp3_music_converter/screens/bookworm/provider/bookworm_provider.dart';
import 'package:mp3_music_converter/screens/bookworm/services/book_services.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/widgets/progress_indicator.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

enum whatToCreate { Folders, SubFolders }

class FolderList extends StatefulWidget {
  final String title;
  FolderList({Key key, @required this.title}) : super(key: key);

  @override
  _FolderListState createState() => _FolderListState();
}

class _FolderListState extends State<FolderList> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  BookwormProvider _bookwormProvider;

  @override
  void initState() {
    _bookwormProvider = Provider.of<BookwormProvider>(context, listen: false);
    _bookwormProvider.getFolders();
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
          text: widget.title,
          color: AppColor.bottomRed,
        ),
        leading: IconButton(
          onPressed: () {
            if (widget.title.toLowerCase() != 'folders')
              File(_bookwormProvider.createdBookPath).delete();
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: AppColor.bottomRed,
          ),
        ),
        actions: [
          createFolderOrSubfolder(
              toCreate: whatToCreate.Folders, context: context),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Consumer<BookwormProvider>(builder: (context, _provider, _) {
          List folders = _provider?.allFolders;
          folders?.sort((a, b) {
            return a
                .toString()
                .toLowerCase()
                .compareTo(b.toString().toLowerCase());
          });
          return ListView.builder(
            itemBuilder: (context, index) {
              return Column(
                children: [
                  MaterialButton(
                    onPressed: () {
                      if (widget.title.toLowerCase() == 'folders')
                        Navigator.push(
                          context,
                          PageTransition(
                              child: FolderDetails(folders[index]),
                              type: PageTransitionType.rightToLeft),
                        );
                      else
                        Navigator.push(
                          context,
                          PageTransition(
                              child: ChooseFolder(folders[index]),
                              type: PageTransitionType.rightToLeft),
                        );
                    },
                    onLongPress: widget.title.toLowerCase() == 'folders'
                        ? () {
                            showFolderOptions(
                                context: context, folderName: folders[index]);
                          }
                        : null,
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
                          folders[index],
                          style: TextStyle(color: Colors.white, fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios,
                            color: Colors.white, size: 15),
                        SizedBox(width: 5)
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                ],
              );
            },
            itemCount: folders.length,
          );
        }),
      ),
    );
  }
}

Widget createFolderOrSubfolder(
    {@required whatToCreate toCreate,
    @required BuildContext context,
    Folder folder}) {
  showTitleInputField() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return TitleInputField(toCreate, folder);
        });
  }

  return GestureDetector(
    onTap: () {
      showTitleInputField();
    },
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      height: 35,
      width: 35,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            color: Colors.red,
            width: 20,
            height: 14,
          ),
          Icon(
            Icons.create_new_folder_rounded,
            color: Colors.white,
            size: 30,
          ),
        ],
      ),
    ),
  );
}

class TitleInputField extends StatefulWidget {
  final whatToCreate toCreate;
  final Folder folder;
  TitleInputField(this.toCreate, this.folder);

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

  createFolder(String title) async {
    String url = "https://youtubeaudio.com/api/book/createfolder";

    try {
      _progressIndicator.show();
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'title': title, 'token': token}));
      _progressIndicator.dismiss();

      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);

        if (data['message'].toString().toLowerCase().contains('created')) {
          showToast(
            context,
            message: 'Folder created',
            backgroundColor: Colors.green,
          );
          // BookwormServices().createFolder(Folder(name: data[]));
          BookwormServices().createFolder(Folder(
              name: data['data']['title'],
              books: [],
              id: data['data']['id'].toString(),
              subfolders: []));
          Provider.of<BookwormProvider>(context, listen: false).getFolders();
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
    } catch (e) {
      _progressIndicator.dismiss();
      setState(() {
        error = 'Failed. Check internet connection';
        showError = true;
      });
    }
  }

  createSubfolder({@required String title, @required Folder folder}) async {
    String url = "https://youtubeaudio.com/api/book/createsubfolder";

    try {
      _progressIndicator.show();
      print(folder.id);
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'title': title, 'token': token, 'fid': folder.id}));
      _progressIndicator.dismiss();

      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        List dataList = data['data'];
        Map details = dataList.firstWhere((e) {
          return e['name'] == title;
        });
        if (data['message'].toString().toLowerCase().contains('created')) {
          showToast(
            context,
            message: 'Subfolder created',
            backgroundColor: Colors.green,
          );
          await BookwormServices().createSubfolder(Subfolder(
              name: details['name'],
              fname: folder.name,
              books: [],
              id: details['id'].toString(),
              fid: details['folder_id'].toString()));
          Provider.of<BookwormProvider>(context, listen: false)
              .getFolderContents(folder.name);
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
    } catch (e) {
      _progressIndicator.dismiss();
      setState(() {
        error = 'Failed. Check internet connection';
        showError = true;
      });
    }
  }

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
                      counterText: ''),
                  controller: _textEditingController,
                  textCapitalization: TextCapitalization.words,
                  maxLength: 20,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'\w')),
                  ],
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
                      if (_formKey.currentState.validate())
                        widget.toCreate == whatToCreate.Folders
                            ? createFolder(_textEditingController.text)
                            : createSubfolder(
                                folder: widget.folder,
                                title: _textEditingController.text);
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
