import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:mp3_music_converter/screens/login/provider/login_provider.dart';
// import 'package:provider/provider.dart';

class SplitAssistant {
  static Future<dynamic> splitFile(
      String filePath, BuildContext context) async {
    print('In the split function');
    print(filePath);
    String baseUrl = "http://67.205.165.56/api/splitter?";

    try {
      var postUri = Uri.parse(baseUrl);
      var request = new http.MultipartRequest("POST", postUri);
      // request.fields['token'] = Provider.of<LoginProviders>(context).userToken;
      request.headers['Content-Type'] = 'multipart/form-data';
      request.fields['token'] =
          'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC82Ny4yMDUuMTY1LjU2IiwiYXVkIjoiaHR0cDpcL1wvNjcuMjA1LjE2NS41NiIsImlhdCI6MTM1Njk5MTUyNCwibmJmIjoxMzU3MDAxMDAwLCJlbWFpbCI6Im9hbnRob255NTkwQGdtYWlsLmNvbSJ9.bE-sdlodX1zMM6Lo0s5RtuVqSlrNq1QJ5vBk6rU-hxI';
      request.files.add(await http.MultipartFile.fromPath('file', filePath));

      var response = await request.send();
      if (response.statusCode == 200) {
        String jsonData = await response.stream.bytesToString();
        print(jsonData);
        var decodedData = jsonDecode(jsonData);
        print(decodedData);
        return decodedData;
      } else {
        print('failed');
        print(response.statusCode);
        print(await response.stream.bytesToString());
        return "Failed";
      }
    } catch (e) {
      print(e);
      return "Failed";
    }
  }

  static Future<bool> saveSplitFiles(
      var decodedData, BuildContext context) async {
    String baseUrl = "http://67.205.165.56/api/savesplit";

    var body = jsonEncode({
      // "token2": Provider.of<LoginProviders>(context, listen: false).userToken,
      "token":
          "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC82Ny4yMDUuMTY1LjU2IiwiYXVkIjoiaHR0cDpcL1wvNjcuMjA1LjE2NS41NiIsImlhdCI6MTM1Njk5MTUyNCwibmJmIjoxMzU3MDAxMDAwLCJlbWFpbCI6Im9hbnRob255NTkwQGdtYWlsLmNvbSJ9.bE-sdlodX1zMM6Lo0s5RtuVqSlrNq1QJ5vBk6rU-hxI",
      "id": decodedData['id'],
      "title": decodedData['title'],
      "files": {
        "bass": decodedData['files']['bass'],
        "voice": decodedData['files']['voice'],
        "drums": decodedData['files']['drums'],
        "other": decodedData['files']['other']
      }
    });

    try {
      final _response = await http.post(baseUrl,
          headers: {
            'Content-Type': 'application/json',
          },
          body: body);

      if (_response.statusCode == 200) {
        return Future.value(true);
      } else {
        return Future.value(false);
      }
    } catch (e) {
      return Future.value(false);
    }
  }
}
