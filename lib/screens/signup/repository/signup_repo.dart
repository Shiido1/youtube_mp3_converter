import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:mp3_music_converter/screens/signup/model/signup_model.dart';
import 'package:http/http.dart' as http;

class SignUpApiRepository {
  String url = 'http://67.205.165.56/api/register';
  Future<Map> signUp({@required Map data}) async {
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      print(response.statusCode);
      print(jsonDecode(response.body));

      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['message'].toString().toLowerCase().contains('success'))
          return {'status': 'success', 'data': SignupModel.fromJson(data)};
        return {'status': 'failed', 'data': 'Failed to create account'};
      } else
        return {
          'status': 'failed',
          'data': jsonDecode(response.body)['message'] ?? 'An error occurred.'
        };
    } catch (e) {
      return {
        'status': 'failed',
        'data':
            'An error occurred. Check your internet connection and try again'
      };
    }
  }
}
