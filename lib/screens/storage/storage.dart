import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/screens/storage/contact_us.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
import 'package:mp3_music_converter/utils/helper/helper.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/widgets/text_view_widget.dart';
import 'package:http/http.dart' as http;

class Storage extends StatefulWidget {
  Storage({Key key}) : super(key: key);

  @override
  _StorageState createState() => _StorageState();
}

class _StorageState extends State<Storage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int totalSplitSongs;

  getProfileDetails() async {
    String baseUrl = "http://159.223.129.191/api/me";
    String token = await preferencesHelper.getStringValues(key: 'token');

    try {
      final response = await http.post(
        baseUrl,
        body: jsonEncode({'token': token}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        setState(() {
          totalSplitSongs = int.parse(data['totalsplitsongs'].toString()) ?? 0;
        });
      } else {
        showToast(context,
            message: 'Request failed. Try again later',
            backgroundColor: Colors.red,
            textColor: Colors.white);
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
      showToast(context,
          message: 'An error occurred. Try again later',
          backgroundColor: Colors.red,
          textColor: Colors.white);
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    getProfileDetails();
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
          text: 'Storage',
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
      body: totalSplitSongs == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                children: [
                  Text(
                    'Total split songs: $totalSplitSongs',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  SizedBox(height: 40),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            CupertinoPageRoute(builder: (_) => ContactUs()));
                      },
                      child: Text(
                        'Contact Us',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
