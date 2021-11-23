import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mp3_music_converter/screens/bookworm/create_book/choose_subfolder.dart';
import 'package:mp3_music_converter/screens/bookworm/folders/folder_details.dart';
import 'package:mp3_music_converter/screens/bookworm/folders/folder_list.dart';
import 'package:mp3_music_converter/screens/bookworm/model/model.dart';
import 'package:mp3_music_converter/screens/bookworm/provider/bookworm_provider.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class ChooseFolder extends StatefulWidget {
  final String folderName;
  ChooseFolder(this.folderName);

  @override
  _ChooseFolderState createState() => _ChooseFolderState();
}

class _ChooseFolderState extends State<ChooseFolder> {
  BookwormProvider _bookwormProvider;
  TextEditingController _controller;
  ScrollController _scrollController;

  @override
  void initState() {
    _bookwormProvider = Provider.of<BookwormProvider>(context, listen: false);
    _bookwormProvider.currentFolder = null;
    _bookwormProvider.getFolderContents(widget.folderName);
    _scrollController = ScrollController();
    _controller = TextEditingController(
      text: widget.folderName,
    )..addListener(() {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Folder currentFolder = Provider.of<BookwormProvider>(context).currentFolder;

    return Scaffold(
      endDrawerEnableOpenDragGesture: false,
      backgroundColor: AppColor.white.withOpacity(0.05),
      appBar: AppBar(
        backgroundColor: AppColor.black,
        title: TextFormField(
          readOnly: true,
          style: TextStyle(
              color: Colors.red, fontSize: 18, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
              border: InputBorder.none, focusedBorder: InputBorder.none),
          toolbarOptions: ToolbarOptions(),
          enableInteractiveSelection: false,
          controller: _controller,
          scrollController: _scrollController,
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
          if (currentFolder != null)
            createFolderOrSubfolder(
                toCreate: whatToCreate.SubFolders,
                context: context,
                folder: currentFolder),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child:
                  Consumer<BookwormProvider>(builder: (context, _provider, _) {
                List subfolders = _provider?.currentFolder?.subfolders;
                subfolders?.sort((a, b) {
                  return a
                      .toString()
                      .toLowerCase()
                      .compareTo(b.toString().toLowerCase());
                });
                if ((_provider?.currentFolder?.books == null ||
                        _provider.currentFolder.books.isEmpty) &&
                    (_provider?.currentFolder?.subfolders == null ||
                        _provider.currentFolder.subfolders.isEmpty))
                  return Center(
                    child: Text(
                      'Folder is empty',
                      style: TextStyle(color: Colors.white),
                    ),
                  );

                return ListView(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            MaterialButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                      child: ChooseSubfolder(
                                          widget.folderName, subfolders[index]),
                                      type: PageTransitionType.rightToLeft),
                                );
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
                                    subfolders[index],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Spacer(),
                                  Icon(Icons.arrow_forward_ios,
                                      color: Colors.white, size: 15),
                                  SizedBox(width: 5)
                                ],
                              ),
                            ),
                            SizedBox(
                                height: index ==
                                        _provider.currentFolder.subfolders
                                                .length -
                                            1
                                    ? 20
                                    : 10),
                          ],
                        );
                      },
                      itemCount: subfolders.length,
                    ),
                  ],
                );
              }),
            ),
          ),
          Container(
            height: 50,
            color: Colors.white12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    File(_bookwormProvider.createdBookPath).delete();
                    Navigator.of(context)..pop()..pop();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red, fontSize: 20),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    addBook(
                      context: context,
                      id: currentFolder.id,
                      folderType: 'folder',
                      createBook: true,
                    );
                  },
                  child: Text(
                    'Select',
                    style: TextStyle(color: Colors.blue, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
