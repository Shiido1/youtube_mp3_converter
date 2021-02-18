import 'package:flutter/cupertino.dart';

class SaveConvert {
  String message;
  String token;
  String id;
  String image;
  String url;
  String title;

  SaveConvert(
      {this.message, this.token, this.id, this.image, this.title, this.url});

  SaveConvert.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    id = json['id'];
    token = json['token'];
    image = json['image'];
    url = json['url'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['token'] = this.token;
    data['id'] = this.id;
    data['image'] = this.image;
    data['title'] = this.title;
    data['url'] = this.url;
    return data;
  }

  static Map<String, dynamic> mapToJson(
      {@required String url, @required String id}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = url;
    data['id'] = id;
    return data;
  }
}
