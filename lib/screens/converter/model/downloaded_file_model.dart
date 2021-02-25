import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class DownloadedFile extends HiveObject {
  @HiveField(0)
  String path;

  @HiveField(1)
  String title;

  @HiveField(2)
  String image;

  DownloadedFile(
    read, {
    this.path,
    this.title,
    this.image,
  });

  DownloadedFile.fromJson(Map<dynamic, dynamic> json) {
    path = json['path'];
    title = json['title'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['path'] = this.path;
    data['title'] = this.title;
    data['image'] = this.image;
    return data;
  }
}
