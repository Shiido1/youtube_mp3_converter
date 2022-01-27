import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:mp3_music_converter/screens/otp/model/otp_model.dart';
import 'package:http/http.dart' as http;

class OtpApiRepository {
  String url = 'http://159.223.129.191/api/rsendotp';
  String vUrl = 'http://159.223.129.191/api/verify';
  Future<Map> verify({@required Map data}) async {
    try {
      final response = await http.post(vUrl,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data));

      print(jsonDecode(response.body));

      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['message'].toString().toLowerCase().contains('success'))
          return {'status': 'success', 'data': OtpModel.fromJson(data)};
        return {'status': 'failed', 'data': data['message']};
      } else {
        return {
          'status': 'failed',
          'data':
              jsonDecode(response.body)['message'] ?? 'OTP verification failed'
        };
      }
    } catch (e) {
      print(e);
      return {'status': 'failed', 'data': 'OTP verification failed'};
    }
  }

  Future<dynamic> resend({@required String email}) async {
    try {
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email}));

      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        if (data['message'].toString().toLowerCase().contains('success'))
          return 'success';
        return 'failed';
      }
      return 'failed';
    } catch (e) {
      return 'failed';
    }
  }
}
