import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mp3_music_converter/screens/bookworm/folders/book_options.dart';
import 'package:mp3_music_converter/screens/bookworm/folders/folder_list.dart';
import 'package:mp3_music_converter/screens/bookworm/folders/subfolder_details.dart';
import 'package:mp3_music_converter/screens/bookworm/folders/subfolder_options.dart';
import 'package:mp3_music_converter/screens/bookworm/model/model.dart';
import 'package:mp3_music_converter/screens/bookworm/provider/bookworm_provider.dart';
import 'package:mp3_music_converter/screens/bookworm/services/book_services.dart';
import 'package:mp3_music_converter/screens/bookworm/view_book/view_book.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
// import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:pdf_render/pdf_render_widgets2.dart';
import 'package:pdf_text/pdf_text.dart';
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
    // Provider.of<BookwormProvider>(context, listen: false)
    //     .getBookDetails(currentFolder?.books);
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
                              // BookwormServices().deleteThis();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => SubfolderDetails(
                                          widget.folderName,
                                          subfolders[index])));
                              // print(_provider.currentFolder.toJson());
                              // _provider.getSubfolderContents(subfolders[index]);
                            },
                            onLongPress: () {
                              _provider.getSubfolderContents(subfolders[index]);
                              showSubfolderOptions(context: context);
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
                                      _provider
                                              .currentFolder.subfolders.length -
                                          1
                                  ? 20
                                  : 10),
                        ],
                      );
                    },
                    itemCount: subfolders.length,
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      List<Book> books = _provider.folderBooks;
                      books?.sort((a, b) {
                        return a.name
                            .toLowerCase()
                            .compareTo(b.name.toLowerCase());
                      });
                      return GestureDetector(
                        onLongPress: () {
                          showBookOptions(context, books[index]);
                        },
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ViewBook(books[index])));
                        },
                        child: Container(
                          height: 260,
                          decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(5)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // SizedBox(height: 0.1),
                              Container(
                                height: 220,
                                margin: EdgeInsets.only(top: 8),
                                child: books[index]?.path != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: PdfDocumentLoader(
                                          filePath: books[index].path,
                                          pageNumber: 1,
                                          pageBuilder: (context, textureBuilder,
                                              pageSize) {
                                            return textureBuilder(
                                              backgroundFill: true,
                                              size: pageSize,
                                              placeholderBuilder:
                                                  (size, status) {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation(
                                                            Colors.white),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          onError: (val) {
                                            return Container(
                                              height: 220,
                                              width: double.infinity,
                                              color: Colors.white,
                                              child: Icon(Icons.warning_rounded,
                                                  size: 60, color: Colors.red),
                                            );
                                          },
                                        ),
                                      )
                                    : Container(),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 7),
                                child: Text(
                                  books[index].name,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    // itemCount: _provider.currentFolder.books.length,
                    itemCount: _provider.folderBooks.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        mainAxisExtent: 260,
                        crossAxisSpacing: 10),
                  ),
                  SizedBox(height: 60),
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
    addBook() async {
      FilePickerResult result = await FilePicker.platform
          .pickFiles(allowedExtensions: ['pdf'], type: FileType.custom);
      if (result != null) {
        BookwormServices().addBook(
          Book(
            fid: '9',
            fname: 'Notme',
            id: '28',
            name: result.files.single.name,
            path: result.files.single.path,
            sname: 'Greatest',
            sid: '18',
          ),
        );
      }
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
