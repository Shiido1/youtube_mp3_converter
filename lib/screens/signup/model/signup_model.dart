import 'package:flutter/material.dart';

class SignupModel {
  String message;
  String email;
  String name;
  String cpassword;
  String username;

  SignupModel(
      {this.message, this.email, this.name, this.username, this.cpassword});

  SignupModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    email = json['email'];
    name = json['name'];
    username = json['username'];
  }

  static Map<String, dynamic> toJson(
      {@required String name,
      @required String email,
      @required String password,
      @required String username,
      @required String cpassword}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['password'] = password;
    data['email'] = email;
    data['name'] = name;
    data['cpassword'] = cpassword;
    data['username'] = username;
    return data;
  }
}
