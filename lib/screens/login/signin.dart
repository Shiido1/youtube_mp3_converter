// import 'dart:convert';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:mp3_music_converter/screens/dashboard/sample_dashboard.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SignIn {
//   signIn(String email, String password) async {
//     Map data = {'email': email, 'password': password};
//     var jsonData = null;
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     var response =
//         await http.post('http://67.205.165.56/api/login', body: data);
//     if (response.statusCode == 200) {
//       jsonData = json.decode(response.body);
//       sharedPreferences.setString('token', jsonData['token']);
//       Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (BuildContext context) => Sample()),
//           (Route<dynamic> route) => false);
//     }
//   }
// }
