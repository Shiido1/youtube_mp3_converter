import 'package:flutter/cupertino.dart';

class SaveConvert {
  String message;

  SaveConvert({this.message});

  SaveConvert.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    return data;
  }

  static Map<String, dynamic> mapToJson({@required int id}){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    return data;
  }
}
