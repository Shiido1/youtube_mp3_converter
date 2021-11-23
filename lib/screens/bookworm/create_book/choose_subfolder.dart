import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mp3_music_converter/screens/bookworm/folders/folder_details.dart';
import 'package:mp3_music_converter/screens/bookworm/provider/bookworm_provider.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:provider/provider.dart';

class ChooseSubfolder extends StatefulWidget {
  final String subfolderName;
  final String folderName;
  ChooseSubfolder(this.folderName, this.subfolderName);

  @override
  _ChooseSubfolderState createState() => _ChooseSubfolderState();
}

class _ChooseSubfolderState extends State<ChooseSubfolder> {
  BookwormProvider _bookwormProvider;
  TextEditingController _controller;
  ScrollController _scrollController;

  @override
  void initState() {
    _bookwormProvider = Provider.of<BookwormProvider>(context, listen: false);
    _bookwormProvider.currentSubfolder = null;
    _bookwormProvider.getSubfolderContents(widget.subfolderName);
    _scrollController = ScrollController();
    _controller = TextEditingController(
      text: widget.folderName + r' \ ' + widget.subfolderName,
    )..addListener(() {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(),
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
                    Navigator.of(context)..pop()..pop()..pop();
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
                      id: Provider.of<BookwormProvider>(context, listen: false)
                          ?.currentSubfolder
                          ?.id,
                      folderType: 'subfolder',
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
