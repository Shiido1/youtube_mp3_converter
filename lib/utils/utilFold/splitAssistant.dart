import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SplitAssistant {
  static Future<Map<String, dynamic>> splitFile({
    String filePath,
    String userToken,
  }) async {
    String baseUrl = "http://67.205.165.56/api/splitter?";

    try {
      var postUri = Uri.parse(baseUrl);
      var request = new http.MultipartRequest("POST", postUri);
      request.headers['Content-Type'] = 'multipart/form-data';
      request.fields['token'] = userToken;

      request.files.add(await http.MultipartFile.fromPath('file', filePath));

      var response = await request.send();
      if (response.statusCode == 200) {
        String jsonData = await response.stream.bytesToString();
        print(jsonData);
        var decodedData = jsonDecode(jsonData);
        print(decodedData);
        String errorMessage = decodedData["message"] ?? null;
        if (errorMessage == null) {
          return {'reply': 'success', 'data': decodedData};
        } else
          return {'reply': 'failed', 'data': errorMessage};
      } else {
        String checkReason = await response.stream.bytesToString();
        String reason = checkReason.contains(':') && checkReason.contains('"')
            ? checkReason
                ?.split(':')[1]
                .split('"')[1]
                .toString()
                .trim()
                .toLowerCase()
            : '';
        print(reason);

        return {'reply': 'failed', 'data': reason};
      }
    } catch (e) {
      return {'reply': 'failed', 'data': ''};
    }
  }

  static Future<Map> saveSplitFiles(
      {var decodedData,
      String userToken,
      @required String songName,
      @required String artistName}) async {
    String baseUrl = "http://67.205.165.56/api/savesplit";

    var body = jsonEncode(
      {
        "token": userToken,
        "bass": decodedData['files']['bass'],
        "voice": decodedData['files']['voice'],
        "drum": decodedData['files']['drums'],
        "others": decodedData['files']['other'],
        "title": decodedData['title'],
        "id": decodedData['id'].toString(),
        'songname': songName,
        'artistname': artistName
      },
    );

    try {
      final _response = await http.post(baseUrl,
          headers: {
            'Content-Type': 'application/json',
          },
          body: body);
      print('status code = ${_response.statusCode}');
      if (_response.statusCode == 200) {
        Map data = jsonDecode(_response.body);
        int vocalid, othersid;
        print(data);
        print(data['message']);
        if (data['message'].toString().toLowerCase().contains('inserted')) {
          for (Map name in data['musicid']) {
            if (name['name'].toString().toLowerCase().trim() == 'voice')
              vocalid = name['id'];
            else if (name['name'].toString().toLowerCase().trim() == 'others')
              othersid = name['id'];
          }
          return {
            'reply': 'success',
            'data': {'vocalid': vocalid, 'othersid': othersid}
          };
        } else
          return {'reply': 'failed', 'data': data['message']};
      } else {
        return {
          'reply': 'failed',
          'data': jsonDecode(_response.body)['message']
        };
      }
    } catch (e) {
      return {
        'reply': 'failed',
        'data': 'Could not get required details. Try again later'
      };
    }
  }
}
