import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mp3_music_converter/screens/bookworm/folders/folder_list.dart';
import 'package:mp3_music_converter/screens/bookworm/folders/subfolder_details.dart';
import 'package:mp3_music_converter/screens/bookworm/model/model.dart';
import 'package:mp3_music_converter/screens/bookworm/provider/bookworm_provider.dart';
import 'package:mp3_music_converter/screens/bookworm/services/book_services.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:provider/provider.dart';

class FolderDetails extends StatefulWidget {
  final String folderName;
  FolderDetails(this.folderName);

  @override
  _FolderDetailsState createState() => _FolderDetailsState();
}

class _FolderDetailsState extends State<FolderDetails> {
  BookwormProvider _bookwormProvider;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _controller;
  ScrollController _scrollController;

  @override
  void initState() {
    // BookwormServices().createSubfolder(
    //     Subfolder(name: 'Woman', id: '10', fid: '8', fname: 'Noname'));
    // BookwormServices().createSubfolder(
    //     Subfolder(name: 'Eben', id: '10', fid: '9', fname: 'Notme', books: []));
    // BookwormServices().deleteSubfolder(Subfolder(
    //     name: 'Namtes', id: '8', fid: '9', fname: 'Notme', books: []));

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
        actions: [
          if (currentFolder != null)
            createFolderOrSubfolder(
                toCreate: whatToCreate.SubFolders,
                context: context,
                folder: currentFolder),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Consumer<BookwormProvider>(builder: (context, _provider, _) {
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
                                  MaterialPageRoute(
                                      builder: (_) => SubfolderDetails(
                                          widget.folderName,
                                          subfolders[index])));
                              // print(_provider.currentFolder.toJson());
                              // _provider.getSubfolderContents(subfolders[index]);
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
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                        ],
                      );
                    },
                    itemCount: subfolders.length,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
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
                                  _provider.currentFolder.books[index],
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                        ],
                      );
                    },
                    itemCount: _provider.currentFolder.books.length,
                  ),
                ],
              );
            }),
          ),
          Positioned(bottom: 20, right: 20, child: AddBookIcon()),
        ],
      ),
    );
  }
}

class AddBookIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    addBook() {
      print('book added');
    }

    return GestureDetector(
      onTap: () {
        addBook();
      },
      child: Container(
        height: 50,
        width: 50,
        alignment: Alignment.center,
        decoration:
            BoxDecoration(color: Colors.white60, shape: BoxShape.circle),
        child: Stack(
          children: [
            Positioned(
              left: 4,
              top: 4,
              bottom: 5,
              right: 3,
              child: Container(
                color: Colors.red,
              ),
            ),
            Positioned(
              left: 4,
              top: 20,
              bottom: 1,
              right: 3,
              child: Container(
                color: Colors.white,
              ),
            ),
            Icon(
              FontAwesomeIcons.book,
              color: Colors.red,
              size: 30,
            ),
            Positioned(
              left: 4,
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
