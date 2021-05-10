import 'package:flutter/material.dart';

class RecorderModel {
  String path;
  String name;
  RecorderModel({this.path, this.name});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> recordedSongMap = Map();
    recordedSongMap['path'] = path;
    recordedSongMap['name'] = name;
    return recordedSongMap;
  }

  RecorderModel.fromMap(Map json) {
    this.path = json['path'];
    this.name = json['name'];
  }
}
