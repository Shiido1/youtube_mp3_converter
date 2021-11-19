import 'package:flutter/material.dart';
import 'package:mp3_music_converter/screens/bookworm/model/model.dart';
import 'package:pdf_render/pdf_render_widgets2.dart';
import 'package:pdf_text/pdf_text.dart';

class ViewBook extends StatefulWidget {
  final Book book;
  ViewBook(this.book);

  @override
  _ViewBookState createState() => _ViewBookState();
}

class _ViewBookState extends State<ViewBook> {
  PDFDoc doc;
  String text;
  PdfViewerController _controller;

  loadDocument() async {
    doc = await PDFDoc.fromPath(widget.book.path);
    text = await doc.text;
    setState(() {});
  }

  @override
  void initState() {
    loadDocument();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PdfDocumentLoader(
        filePath: widget.book.path,
        documentBuilder: (context, doc, pageCount) {
          return LayoutBuilder(builder: (context, constraints) {
            return InteractiveViewer(
              maxScale: 20,
              minScale: 0.1,
              child: ListView.builder(
                  itemCount: pageCount,
                  itemBuilder: (context, index) {
                    return PdfPageView(
                      pageNumber: index + 1,
                      // pdfDocument: doc,
                      pageBuilder: (context, textureBuilder, pageSize) {
                        return Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                                color: Colors.black,
                                blurRadius: 4,
                                offset: Offset(2, 2))
                          ]),
                          child: textureBuilder(),
                        );
                      },
                    );
                  }),
            );
          });
        },
      ),
      // PdfViewer(
      //   filePath: widget.book.path,
      //   onViewerControllerInitialized: (PdfViewerController controller) {
      //     _controller = controller;
      //   },
      // ),
    );
  }
}
