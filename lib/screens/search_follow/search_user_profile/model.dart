class SearchUserProfile {
  User user;
  List<Null> musics;
  Latest latest;
  List<Null> followers;
  List<Null> following;

  SearchUserProfile(
      {this.user, this.musics, this.latest, this.followers, this.following});

  SearchUserProfile.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['musics'] != null) {
      musics = [];
      json['musics'].forEach((v) {
        // musics.add(new Null.fromJson(v));
      });
    }
    latest =
    json['latest'] != null ? new Latest.fromJson(json['latest']) : null;
    if (json['followers'] != null) {
      followers = [];
      json['followers'].forEach((v) {
        followers.add((v));
      });
    }
    if (json['following'] != null) {
      following = [];
      json['following'].forEach((v) {
        following.add((v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.musics != null) {
      data['musics'] = this.musics.map((v) => v).toList();
    }
    if (this.latest != null) {
      data['latest'] = this.latest.toJson();
    }
    if (this.followers != null) {
      data['followers'] = this.followers.map((v) => v).toList();
    }
    if (this.following != null) {
      data['following'] = this.following.map((v) => v).toList();
    }
    return data;
  }
}

class User {
  String name;
  String createdAt;
  Null hideprofile;
  int id;
  String profilepic;

  User({this.name, this.createdAt, this.hideprofile, this.id, this.profilepic});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    createdAt = json['created_at'];
    hideprofile = json['hideprofile'];
    id = json['id'];
    profilepic = json['profilepic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['hideprofile'] = this.hideprofile;
    data['id'] = this.id;
    data['profilepic'] = this.profilepic;
    return data;
  }
}

class Latest {
  int id;
  int top;
  String musicid;
  int userid;
  String type;
  String name;
  Null mid;
  int public;
  String played;
  int category;
  String createdAt;

  Latest(
      {this.id,
        this.top,
        this.musicid,
        this.userid,
        this.type,
        this.name,
        this.mid,
        this.public,
        this.played,
        this.category,
        this.createdAt});

  Latest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    top = json['top'];
    musicid = json['musicid'];
    userid = json['userid'];
    type = json['type'];
    name = json['name'];
    mid = json['mid'];
    public = json['public'];
    played = json['played'];
    category = json['category'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['top'] = this.top;
    data['musicid'] = this.musicid;
    data['userid'] = this.userid;
    data['type'] = this.type;
    data['name'] = this.name;
    data['mid'] = this.mid;
    data['public'] = this.public;
    data['played'] = this.played;
    data['category'] = this.category;
    data['created_at'] = this.createdAt;
    return data;
  }
}