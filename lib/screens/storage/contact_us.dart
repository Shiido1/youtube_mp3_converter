import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mp3_music_converter/screens/split/split_loader.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/widgets/progress_indicator.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:http/http.dart' as http;

class ContactUs extends StatefulWidget {
  ContactUs({Key key}) : super(key: key);

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _textEditingController;
  TextEditingController _otherEditingController;
  CustomProgressIndicator _progressIndicator;
  final _formKey = GlobalKey<FormState>();
  String category;
  String name;
  String email;

  getValues() async {
    name = await preferencesHelper.getStringValues(key: 'name');
    email = await preferencesHelper.getStringValues(key: 'email');
  }

  sendComment() async {
    String url = "https://youtubeaudio.ca/api/contactus";
    _progressIndicator.show();
    final response = await http.post(url,
        body: jsonEncode({
          'fullname': name,
          'title': category?.toLowerCase() == "other"
              ? _otherEditingController.text
              : category,
          'email': email,
          'body': _textEditingController.text
        }),
        headers: {"Content-Type": "application/json"});
    _progressIndicator.dismiss();

    if (response.statusCode == 200) {
      Map data = jsonDecode(response.body);
      if (data['message'].toString().toLowerCase().contains('success')) {
        showToast(context,
            message: 'Comment sent',
            backgroundColor: Colors.green,
            gravity: 1,
            duration: 2,
            textColor: Colors.white);
        Navigator.pop(context);
      } else
        showToast(context,
            message: 'Failed to send comment',
            backgroundColor: Colors.red,
            gravity: 1,
            textColor: Colors.white);
    } else
      showToast(context,
          message: 'Failed to send comment',
          backgroundColor: Colors.red,
          gravity: 1,
          textColor: Colors.white);
  }

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _otherEditingController = TextEditingController();
    _progressIndicator = CustomProgressIndicator(context);
    getValues();
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
          text: 'Contact Us',
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
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    items: [
                      DropdownMenuItem(child: Text('Split'), value: 'Split'),
                      DropdownMenuItem(
                          child: Text('Bookworm'), value: 'Bookworm'),
                      DropdownMenuItem(child: Text('Other'), value: 'Other'),
                    ],
                    value: category,
                    onChanged: (val) {
                      setState(() {
                        category = val;
                      });
                    },
                    validator: (val) {
                      return val == null ? 'Please select a category' : null;
                    },
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Select category',
                      hintStyle: TextStyle(color: Colors.white54),
                    ),
                    style: TextStyle(color: Colors.white),
                    dropdownColor: Colors.grey[800],
                  ),
                  SizedBox(height: 15),
                  if (category?.toLowerCase() == "other")
                    TextFormField(
                      controller: _otherEditingController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      maxLength: 20,
                      cursorHeight: 15,
                      validator: (val) {
                        return val.trim().isEmpty
                            ? "Please enter a category"
                            : null;
                      },
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'Enter a category',
                        hintStyle: TextStyle(color: Colors.white54),
                      ),
                      textCapitalization: TextCapitalization.words,
                    ),
                  SizedBox(
                      height: category?.toLowerCase() == "other" ? 20 : 15),
                  TextFormField(
                    controller: _textEditingController,
                    minLines: 8,
                    maxLines: 8,
                    maxLength: 1000,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    cursorHeight: 15,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'Comments',
                        hintStyle: TextStyle(color: Colors.white54),
                        counterText: ''),
                    validator: (val) {
                      return val.trim().isEmpty
                          ? "Please enter your comment"
                          : null;
                    },
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: MaterialButton(
                  color: Colors.red[500],
                  height: 40,
                  textColor: Colors.white,
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      // print(_textEditingController.text);
                      // print(name);
                      // print(_otherEditingController.text);
                      // print(email);
                      // _textEditingController.clear();
                      sendComment();
                    }
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    'Send',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
