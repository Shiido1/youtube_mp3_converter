import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OtpModel {
  String message;
  int totalsong;
  List<Null> invoices;
  int totalsplitsongs;
  String storage;
  String token;
  String name;
  Null background;
  Null color;
  String profilepic;
  Null about;
  int totalplayed;
  int followers;
  int following;

  OtpModel(
      {this.message,
      this.totalsong,
      this.invoices,
      this.totalsplitsongs,
      this.storage,
      this.token,
      this.name,
      this.background,
      this.color,
      this.profilepic,
      this.about,
      this.totalplayed,
      this.followers,
      this.following});

  OtpModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    totalsong = json['totalsong'];
    if (json['invoices'] != null) {
      invoices = new List<Null>();
      json['invoices'].forEach((v) {
        invoices.add((v));
      });
    }
    totalsplitsongs = json['totalsplitsongs'];
    storage = json['storage'];
    token = json['token'];
    name = json['name'];
    background = json['background'];
    color = json['color'];
    profilepic = json['profilepic'];
    about = json['about'];
    totalplayed = json['totalplayed'];
    followers = json['followers'];
    following = json['following'];
  }

  static Map<String, dynamic> toJson({
    @required int otp,
    @required String email,
  }) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otp'] = otp;
    data['email'] = email;
    return data;
  }

  static Map<String, dynamic> resendOtpToJson({
    @required String email,
    @required int otp,
  }) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = email;
    data['otp'] = otp;
    return data;
  }
}
