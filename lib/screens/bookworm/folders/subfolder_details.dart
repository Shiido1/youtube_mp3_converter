import 'package:flutter/material.dart';
import 'package:mp3_music_converter/screens/bookworm/folders/book_options.dart';
import 'package:mp3_music_converter/screens/bookworm/folders/folder_details.dart';
import 'package:mp3_music_converter/screens/bookworm/model/model.dart';
import 'package:mp3_music_converter/screens/bookworm/provider/bookworm_provider.dart';
import 'package:mp3_music_converter/screens/bookworm/view_book/view_book.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pdf_render/pdf_render_widgets2.dart';
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Consumer<BookwormProvider>(builder: (context, _provider, _) {
              List<Book> books = _provider?.subfolderBooks;
              books?.sort((a, b) {
                return a?.name
                    ?.toLowerCase()
                    ?.compareTo(b?.name?.toLowerCase());
              });

              if (_provider?.currentSubfolder?.books == null ||
                  _provider.currentSubfolder.books.isEmpty)
                return Center(
                  child: Text(
                    'Subfolder is empty',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              return GridView.builder(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onLongPress: () {
                      showBookOptions(context, books[index]);
                    },
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                            child: ViewBook(books[index]),
                            type: PageTransitionType.fade),
                      );
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
                          Container(
                            height: 220,
                            margin: EdgeInsets.only(top: 8),
                            child: books[index]?.path != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: PdfDocumentLoader(
                                      filePath: books[index].path,
                                      pageNumber: 1,
                                      pageBuilder: (
                                        context,
                                        textureBuilder,
                                        pageSize,
                                      ) {
                                        return textureBuilder(
                                          backgroundFill: true,
                                          size: pageSize,
                                          placeholderBuilder: (size, status) {
                                            // return status == PdfPageStatus.loading

                                            //     ?
                                            return Center(
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation(
                                                  Colors.white,
                                                ),
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: books.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    mainAxisExtent: 260,
                    crossAxisSpacing: 10),
              );
            }),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: AddBookIcon(
              'subfolder',
            ),
          ),
        ],
      ),
    );
  }
}
