import 'package:flutter/cupertino.dart';

class SignupModel {
  String message;
  String email;
  String name;

  SignupModel({this.message, this.email, this.name});

  SignupModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    email = json['email'];
    name = json['name'];
  }

  static Map<String, dynamic> toJson(
      {@required String name,
      @required String email,
      @required String password}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['password'] = password;
    data['email'] = email;
    data['name'] = name;
    return data;
  }
}
