import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class DownloadedFile extends HiveObject {
  @HiveField(0)
  String path;

  @HiveField(1)
  String title;

  DownloadedFile({this.path, this.title});

  DownloadedFile.fromJson(Map<String, dynamic> json) {
    path = json['path'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['path'] = this.path;
    data['title'] = this.title;
  }
}

class YoutubeModel {
  String message;
  int id;
  String image;
  String url;
  String title;
  String filesize;

  YoutubeModel(
      {this.message, this.id, this.image, this.url, this.title, this.filesize});

  YoutubeModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    id = json['id'];
    image = json['image'];
    url = json['url'];
    title = json['title'];
    filesize = json['filesize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['id'] = this.id;
    data['image'] = this.image;
    data['url'] = this.url;
    data['title'] = this.title;
    data['filesize'] = this.filesize;
    return data;
  }

  static Map<String, dynamic> mapToJson({@required String url}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = url;
    return data;
  }
}
