import 'dart:io';

import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_pdf/pdf.dart' as sf;

class CreateBook extends StatefulWidget {
  CreateBook({Key key}) : super(key: key);

  @override
  _CreateBookState createState() => _CreateBookState();
}

class _CreateBookState extends State<CreateBook> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _textEditingController;
  pw.Document pdf = pw.Document();

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  createPdf(String text) async {
    // pw.Text yt = pw.Text(text);
    // print(PdfPageFormat.a4);
    // final sf.PdfDocument doc = sf.PdfDocument();

    // doc.pages.add().graphics.drawString(s, font);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        footer: (pw.Context context) {
          return pw.Center(
              child: pw.Container(
            alignment: pw.Alignment.center,
            width: 40,
            padding: pw.EdgeInsets.all(5),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey),
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Text(
              context.pageNumber.toString(),
              style: pw.TextStyle(color: PdfColors.black),
            ),
          ));
        },
        build: (pw.Context context) {
          return [
            pw.Column(children: [
              pw.Text(text, textAlign: pw.TextAlign.justify),
            ])
          ];
        },
      ),
    );

    final file = Platform.isAndroid
        ? await DownloadsPathProvider.downloadsDirectory
        : await getApplicationDocumentsDirectory();
    final output = File('${file.path}/mypdf.pdf');
    output.writeAsBytesSync(await pdf.save());
    print(file.path);
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
          text: 'Create Book',
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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: ListView(children: [
          Text(
            "Text",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          SizedBox(height: 8),
          Form(
            child: TextFormField(
              controller: _textEditingController,
              minLines: 10,
              maxLines: 15,
              maxLength: 20000,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              cursorHeight: 15,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                counterStyle: TextStyle(color: Colors.white54),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(6),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(6),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(6),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(6),
                ),
                hintText: 'Enter text',
                hintStyle: TextStyle(color: Colors.white54),
              ),
              validator: (val) {
                return val.trim().isEmpty ? "Please enter some text" : null;
              },
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          SizedBox(height: 15),
          Align(
            alignment: Alignment.centerRight,
            child: MaterialButton(
              onPressed: () {
                createPdf(_textEditingController.text.trim());
              },
              color: Colors.white24,
              child: Text(
                'Create',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
