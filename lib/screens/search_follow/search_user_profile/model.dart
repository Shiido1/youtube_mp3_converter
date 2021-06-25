class SearchUserProfile {
  int totalfollowers;
  int totalfollowing;
  User user;
  List<Null> musics;
  Latest latest;
  List<Followers> followers;
  List<Following> following;

  SearchUserProfile(
      {this.totalfollowers,
        this.totalfollowing,
        this.user,
        this.musics,
        this.latest,
        this.followers,
        this.following});

  SearchUserProfile.fromJson(Map<String, dynamic> json) {
    totalfollowers = json['totalfollowers']== null ? null : json['totalfollowers'];
    totalfollowing = json['totalfollowing']== null ? null : json['totalfollowing'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['musics'] != null) {
      musics =[];
      json['musics'].forEach((v) {
        musics.add((v));
      });
    }
    latest =
    json['latest'] != null ? new Latest.fromJson(json['latest']) : null;
    if (json['followers'] != null) {
      followers = [];
      json['followers'].forEach((v) {
        followers.add(new Followers.fromJson(v));
      });
    }
    if (json['following'] != null) {
      following = [];
      json['following'].forEach((v) {
        following.add(new Following.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalfollowers'] = this.totalfollowers;
    data['totalfollowing'] = this.totalfollowing;
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
      data['followers'] = this.followers.map((v) => v.toJson()).toList();
    }
    if (this.following != null) {
      data['following'] = this.following.map((v) => v.toJson()).toList();
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

class Followers {
  int id;
  String followerid;
  String userid;
  String createdAt;

  Followers({this.id, this.followerid, this.userid, this.createdAt});

  Followers.fromJson(Map<String, dynamic> json) {
    id = json['id']== null ? null : json['id'];
    followerid = json['followerid']== null ? null : json['followerid'];
    userid = json['userid']== null ? null : json['userid'];
    createdAt = json['created_at']== null ? null : json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['followerid'] = this.followerid;
    data['userid'] = this.userid;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class Following {
  int id;
  String followerid;
  String userid;
  String createdAt;

  Following({this.id, this.followerid, this.userid, this.createdAt});

  Following.fromJson(Map<String, dynamic> json) {
    id = json['id']== null ? null : json['id'];
    followerid = json['followerid']== null ? null : json['followerid'];
    userid = json['userid']== null ? null : json['userid'];
    createdAt = json['created_at']== null ? null : json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['followerid'] = this.followerid;
    data['userid'] = this.userid;
    data['created_at'] = this.createdAt;
    return data;
  }
}