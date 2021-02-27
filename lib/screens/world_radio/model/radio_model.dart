import 'package:flutter/cupertino.dart';

class RadioModel {
  String message;
  List<Radio> radio;
  List<Favourite> favourite;

  RadioModel({this.message, this.radio, this.favourite});

  RadioModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];

    if (json['radio'] != null) {
      radio = new List<Radio>();
      json['radio'].forEach((v) {
        radio.add(new Radio.fromJson(v));
      });
    }
    if (json['favourite'] != null) {
      favourite = new List<Favourite>();
      json['favourite'].forEach((v) {
        favourite.add(new Favourite.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.radio != null) {
      data['radio'] = this.radio.map((v) => v.toJson()).toList();
    }
    if (this.favourite != null) {
      data['favourite'] = this.favourite.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Radio {
  int uid;
  String id;
  String name;
  String slug;
  Null website;
  String placeName;
  String placeLat;
  String placeLong;
  String functioning;
  String secure;
  String countryName;
  String countryCode;
  String mp3;
  String createdAt;

  Radio(
      {this.uid,
      this.id,
      this.name,
      this.slug,
      this.website,
      this.placeName,
      this.placeLat,
      this.placeLong,
      this.functioning,
      this.secure,
      this.countryName,
      this.countryCode,
      this.mp3,
      this.createdAt});

  Radio.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    website = json['website'];
    placeName = json['place_name'];
    placeLat = json['place_lat'];
    placeLong = json['place_long'];
    functioning = json['functioning'];
    secure = json['secure'];
    countryName = json['country_name'];
    countryCode = json['country_code'];
    mp3 = json['mp3'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['website'] = this.website;
    data['place_name'] = this.placeName;
    data['place_lat'] = this.placeLat;
    data['place_long'] = this.placeLong;
    data['functioning'] = this.functioning;
    data['secure'] = this.secure;
    data['country_name'] = this.countryName;
    data['country_code'] = this.countryCode;
    data['mp3'] = this.mp3;
    data['created_at'] = this.createdAt;
    return data;
  }

  static Map<String, dynamic> mapToJson({@required String token, String name}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = token;
    data['name'] = name;
    return data;
  }
}

class Favourite {
  int uid;
  String id;
  String name;
  String slug;
  Null website;
  String placeName;
  String placeLat;
  String placeLong;
  String functioning;
  String secure;
  String countryName;
  String countryCode;
  String mp3;
  String createdAt;

  Favourite(
      {this.uid,
      this.id,
      this.name,
      this.slug,
      this.website,
      this.placeName,
      this.placeLat,
      this.placeLong,
      this.functioning,
      this.secure,
      this.countryName,
      this.countryCode,
      this.mp3,
      this.createdAt});

  Favourite.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    website = json['website'];
    placeName = json['place_name'];
    placeLat = json['place_lat'];
    placeLong = json['place_long'];
    functioning = json['functioning'];
    secure = json['secure'];
    countryName = json['country_name'];
    countryCode = json['country_code'];
    mp3 = json['mp3'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['website'] = this.website;
    data['place_name'] = this.placeName;
    data['place_lat'] = this.placeLat;
    data['place_long'] = this.placeLong;
    data['functioning'] = this.functioning;
    data['secure'] = this.secure;
    data['country_name'] = this.countryName;
    data['country_code'] = this.countryCode;
    data['mp3'] = this.mp3;
    data['created_at'] = this.createdAt;
    return data;
  }
}
