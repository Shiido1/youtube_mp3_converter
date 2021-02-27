import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mp3_music_converter/screens/converter/model/downloaded_file_model.dart';

class DownloadedFileAdapter extends TypeAdapter<DownloadedFile> {
  @override
  final typeId = 0;

  @override
  DownloadedFile read(BinaryReader reader) {
    return DownloadedFile(reader);
  }

  @override
  void write(BinaryWriter writer, DownloadedFile obj) {
    writer.write(obj.path);
    writer.write(obj.title);
    writer.write(obj.image);
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
