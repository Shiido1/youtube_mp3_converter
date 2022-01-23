import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:http/http.dart' as http;

class PublicShare extends StatefulWidget {
  final int libid;
  final int vocalLibid;
  PublicShare(this.libid, {this.vocalLibid});

  @override
  _PublicShareState createState() => _PublicShareState();
}

class _PublicShareState extends State<PublicShare> {
  String selectedVal;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _commentController;

  @override
  void initState() {
    _commentController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  shareSong(String comment, int id) async {
    String baseUrl = 'http://67.205.165.56/api/sharepublic';
    String token = await preferencesHelper.getStringValues(key: 'token');
    String musicType = selectedVal == 'Clean' ? 'clean' : 'dirty';

    try {
      final response = await http.post(
        baseUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'token': token,
          'music_type': musicType,
          'music_comment': comment,
          'id': id
        }),
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['message'].toString().toLowerCase().trim() ==
            'shared to public!') {
          showToast(context,
              message: 'Song successfully shared to public',
              backgroundColor: Colors.white,
              textColor: Colors.black);
          Navigator.pop(context);
        } else
          showToast(context,
              message: 'Fail to share song. Try again later.',
              backgroundColor: Colors.white,
              textColor: Colors.black);
      } else {
        final responseBody = jsonDecode(response.body);
        showToast(context,
            message: responseBody['message'],
            backgroundColor: Colors.white,
            textColor: Colors.black);
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
      showToast(context,
          message: 'Failed to share song. Try again later.',
          backgroundColor: Colors.white,
          textColor: Colors.black);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: AppColor.black,
        title: TextViewWidget(
          text: 'Share to youtubeaudio.ca',
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
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: buildShareSongs(),
      ),
    );
  }

  Widget buildShareSongs() {
    List<String> musicType = ['Clean', 'Dirty (18+)'];
    return Form(
      key: _formKey,
      child: ListView(children: [
        SizedBox(height: 20),
        DropdownButtonFormField(
            style: TextStyle(color: Colors.white, fontSize: 18),
            items: musicType
                .map((e) => DropdownMenuItem(
                      child: Text(e),
                      value: e,
                    ))
                .toList(),
            value: selectedVal,
            dropdownColor: Colors.brown[800],
            decoration: decoration.copyWith(
                hintText: 'Select music type', labelText: 'Music type'),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (val) {
              setState(() {
                selectedVal = val;
              });
            },
            validator: (val) {
              return val == null ? 'Select a music type' : null;
            }),
        SizedBox(height: 20),
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: _commentController,
          decoration: decoration.copyWith(
            labelText: 'Comment',
            hintText: 'Add comment here',
          ),
          validator: (val) {
            return val.isNotEmpty ? null : 'Enter comment';
          },
          style: TextStyle(
            color: AppColor.white,
          ),
          minLines: 2,
          maxLines: 5,
          maxLength: 150,
        ),
        SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red)),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
            SizedBox(width: 70),
            TextButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  shareSong(_commentController.text, widget.libid);
                  if (widget.vocalLibid != null)
                    shareSong(_commentController.text, widget.vocalLibid);
                }
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue)),
              child: Text(
                'Share',
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
          ],
        )
      ]),
    );
  }
}

final decoration = InputDecoration(
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(16.0),
    borderSide: BorderSide(color: AppColor.white),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(16.0),
    borderSide: BorderSide(color: AppColor.white),
  ),
  counterStyle: TextStyle(color: Colors.white),
  border: new OutlineInputBorder(
    borderRadius: BorderRadius.circular(16.0),
    borderSide: BorderSide(color: AppColor.white),
  ),
  counterText: '',
  labelStyle: TextStyle(color: AppColor.white),
  hintStyle: TextStyle(color: AppColor.white),
);
