import 'package:flutter/material.dart';
import 'package:mp3_music_converter/screens/bookworm/folders/folder_details.dart';
import 'package:mp3_music_converter/screens/bookworm/provider/bookworm_provider.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:provider/provider.dart';

class SubfolderDetails extends StatefulWidget {
  final String subfolderName;
  final String folderName;
  SubfolderDetails(this.folderName, this.subfolderName);

  @override
  _SubfolderDetailsState createState() => _SubfolderDetailsState();
}

class _SubfolderDetailsState extends State<SubfolderDetails> {
  BookwormProvider _bookwormProvider;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
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
      key: _scaffoldKey,
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
      body: Stack(
        children: [
          Positioned(bottom: 20, right: 20, child: AddBookIcon()),
        ],
      ),
    );
  }
}
