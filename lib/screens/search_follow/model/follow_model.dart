class FollowModel {
  int played;
  int count;
  String message;

  FollowModel({this.played, this.count, this.message});

  FollowModel.fromJson(Map<String, dynamic> json) {
    played = json['played']== null ? null : json['played'];
    count = json['count']== null ? null : json['count'];
    message = json['message']== null ? null : json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['played'] = this.played;
    data['count'] = this.count;
    data['message'] = this.message;
    return data;
  }
}