import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';

class CreateBook extends StatefulWidget {
  CreateBook({Key key}) : super(key: key);

  @override
  _CreateBookState createState() => _CreateBookState();
}

class _CreateBookState extends State<CreateBook> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _textEditingController;
  TextEditingController _titleEditingController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _titleEditingController = TextEditingController();
    _textEditingController = TextEditingController();
    super.initState();
  }

  createPdf(String title, String text) async {
    pw.Document pdf = pw.Document();
    TextStyle style = TextStyle(
        color: Colors.black,
        fontSize: 18,
        height: 3,
        fontFamily: 'Montserrat',
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.normal);
    List<String> sharedTexts = shareTextToPages(
      context: context,
      text: text,
      style: style,
      pageSize: Size(
          PdfPageFormat.a4.availableWidth, PdfPageFormat.a4.availableHeight),
    );
    final byteData = await rootBundle.load('fonts/Montserrat-Regular.ttf');
    final byteDataBold = await rootBundle.load('fonts/Montserrat-Bold.ttf');
    final ttf = pw.Font.ttf(byteData.buffer.asByteData());
    final ttfBold = pw.Font.ttf(byteDataBold.buffer.asByteData());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
              decoration: pw.BoxDecoration(
                borderRadius: pw.BorderRadius.circular(12),
                border: pw.Border.all(color: PdfColors.black),
              ),
              margin: pw.EdgeInsets.all(0),
              padding: pw.EdgeInsets.all(10),
              child: pw.Center(
                child: pw.Text(title.toUpperCase(),
                    style: pw.TextStyle(
                        font: ttfBold,
                        fontSize: 30,
                        lineSpacing: 10,
                        wordSpacing: 1.5),
                    textAlign: pw.TextAlign.center),
              ));
        },
      ),
    );

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
            pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: sharedTexts
                    .map(
                      (e) => pw.Center(
                        child: pw.Text(
                          e,
                          style: pw.TextStyle(
                            fontSize: 18,
                            lineSpacing: 4.6,
                            font: ttf,
                            color: PdfColors.black,
                            fontWeight: pw.FontWeight.normal,
                          ),
                          textAlign: pw.TextAlign.justify,
                        ),
                      ),
                    )
                    .toList()),
          ];
        },
      ),
    );

    final file = Platform.isAndroid
        ? await DownloadsPathProvider.downloadsDirectory
        : await getApplicationDocumentsDirectory();
    final output = File('${file.path}/$title.pdf');
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
      body: LayoutBuilder(builder: (context, constraint) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 20,
                      child: Text(
                        "Title",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _titleEditingController,
                      maxLength: 100,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      cursorHeight: 15,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        counterText: '',
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
                        hintText: 'Enter title',
                        hintStyle: TextStyle(color: Colors.white54),
                      ),
                      validator: (val) {
                        return val.trim().isEmpty ? "Please enter title" : null;
                      },
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    SizedBox(height: 25),
                    Container(
                      height: 20,
                      child: Text(
                        "Text",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _textEditingController,
                        minLines: null,
                        maxLines: null,
                        expands: true,
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
                        textAlignVertical: TextAlignVertical.top,
                        validator: (val) {
                          return val.trim().isEmpty
                              ? "Please enter some text"
                              : null;
                        },
                        textCapitalization: TextCapitalization.sentences,
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: MaterialButton(
                  onPressed: () {
                    if (_formKey.currentState.validate())
                      createPdf(_titleEditingController.text.trim(),
                          _textEditingController.text.trim());
                  },
                  color: Colors.white24,
                  height: 40,
                  child: Text(
                    'Create',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ]),
        );
      }),
    );
  }
}

List shareTextToPages(
    {@required BuildContext context,
    @required String text,
    @required TextStyle style,
    @required Size pageSize}) {
  List words = text.split(' ');
  String jointText = words[0];
  List<String> textStringList = [];

  for (int i = 0; i < words.length; i++) {
    TextSpan textSpan = TextSpan(text: jointText, style: style);
    TextPainter textPainter = TextPainter(
      text: textSpan,
      maxLines:
          (pageSize.height / (style.fontSize * style.height).ceil()).floor(),
    );
    textPainter.textDirection = TextDirection.ltr;
    textPainter.textAlign = TextAlign.justify;
    textPainter.layout(maxWidth: pageSize.width);
    if (textPainter.didExceedMaxLines) {
      List pageText = jointText.split(' ');
      pageText.removeLast();
      textStringList.add(pageText.join(' '));
      jointText = words[i - 1] + ' ' + words[i];
    } else {
      jointText = jointText + ' ' + words[i];
      if (i == words.length - 1) textStringList.add(jointText);
    }
  }

  return textStringList;
}
