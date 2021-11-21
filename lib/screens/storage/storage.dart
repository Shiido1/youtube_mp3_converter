import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/screens/storage/contact_us.dart';
import 'package:mp3_music_converter/utils/color_assets/color.dart';
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

  getProfileDetails() async {
    String baseUrl = "http://67.205.165.56/api/me";
    String token = await preferencesHelper.getStringValues(key: 'token');

    try {
      final response = await http.post(
        baseUrl,
        body: jsonEncode({'token': token}),
        headers: {'Content-Type': 'application/json'},
      );
      print(response.statusCode);
      print(jsonDecode(response.body));
      if (response.statusCode == 200) {
        Map decodedResponse = jsonDecode(response.body);
        print(decodedResponse);
      } else {}
    } catch (e) {
      print(e);
    }
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
      body: Column(
        children: [
          TextButton(
              onPressed: () {
                Navigator.push(
                    context, CupertinoPageRoute(builder: (_) => ContactUs()));
              },
              child: Text(
                'Contact Us',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }
}
