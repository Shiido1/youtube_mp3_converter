import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mp3_music_converter/screens/login/provider/login_provider.dart';
// import 'package:mp3_music_converter/screens/login/provider/login_provider.dart';
// import 'package:provider/provider.dart';

class SplitAssistant {
  LoginProviders _provider = LoginProviders();
  // String userToken =
  //     'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC82Ny4yMDUuMTY1LjU2IiwiYXVkIjoiaHR0cDpcL1wvNjcuMjA1LjE2NS41NiIsImlhdCI6MTM1Njk5MTUyNCwibmJmIjoxMzU3MDAxMDAwLCJlbWFpbCI6InByZWJhZDUwQGdtYWlsLmNvbSJ9.QNDikltIgKrfOnO6NWxCWDSw5kDmYUrN9WYez24GvsU';
  String userToken;
  Future getUserToken() async {
    await _provider.getSavedUserToken();
    String token = _provider.userToken;
    // userToken = token;
  }

  Future<dynamic> splitFile(String filePath, BuildContext context) async {
    await getUserToken();
    print('In the split function');
    print(filePath);
    String baseUrl = "http://67.205.165.56/api/splitter";
    print(userToken);

    try {
      var postUri = Uri.parse(baseUrl);
      var request = new http.MultipartRequest("POST", postUri);
      request.headers['Content-Type'] = 'multipart/form-data';
      request.fields['token'] = userToken;
      request.files.add(await http.MultipartFile.fromPath('file', filePath));

      var response = await request.send();
      if (response.statusCode == 200) {
        String jsonData = await response.stream.bytesToString();
        var decodedData = jsonDecode(jsonData);
        print(decodedData);
        print(decodedData['files']['bass']);
        saveSplitFiles(decodedData, context);
        getUserLibrary();
        return decodedData;
      } else {
        print('failed to get song');
        return "Failed";
      }
    } catch (e) {
      print(e);
      return "Failed to get song ";
    }
  }

  Future<bool> saveSplitFiles(var decodedData, BuildContext context) async {
    await getUserToken();
    String baseUrl = "http://67.205.165.56/api/savesplit";

    var body = jsonEncode({
      "token": userToken,
      "bass": decodedData['files']['bass'],
      "voice": decodedData['files']['voice'],
      "drums": decodedData['files']['drums'],
      "other": decodedData['files']['other'],
      "title": decodedData['title']
    });

    try {
      final _response = await http.post(baseUrl,
          headers: {
            'Content-Type': 'application/json',
          },
          body: body);

      if (_response.statusCode == 200) {
        print(json.decode(_response.body));
        // getUserLibrary();
        return Future.value(true);
      } else {
        print(_response.statusCode);
        print(_response.reasonPhrase);
        // getUserLibrary();
        print('failed');
        return Future.value(false);
      }
    } catch (e) {
      print(e);
      return Future.value(false);
    }
  }

  Future getUserLibrary() async {
    await getUserToken();
    String baseUrl = "http://67.205.165.56/api/mylib";

    var body = jsonEncode({
      "token": userToken,
    });

    try {
      final _response = await http.post(baseUrl, body: body, headers: {
        'Content-Type': 'application/json',
      });
      if (_response.statusCode == 200) {
        final decodedData = jsonDecode(_response.body);
        print(decodedData);
      }
    } catch (_) {
      print(_);
    }
  }
}
