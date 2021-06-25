

class SearchUser {
  List<Users> users=[];

  SearchUser({this.users});

  SearchUser.fromJson(Map<String, dynamic> json) {
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        try{
          users.add(new Users.fromJson(v));
        }catch(e){}
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.users != null) {
      data['users'] = this.users.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Users {
  String name;
  String profilePic;
  int id;

  Users({this.name, this.profilePic, this.id});

  Users.fromJson(Map<String, dynamic> json) {
    name = json['name'] == null ? null : json['name'];
    profilePic = json['profile_pic'] == null ? null : json['profile_pic'];
    id = json['id'] ==null ? null : json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['profile_pic'] = this.profilePic;
    data['id'] = this.id;
    return data;
  }
}