class SignupModel {
  String message;
  String email;
  String name;
  String username;

  SignupModel({this.message, this.email, this.name, this.username});

  SignupModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    email = json['email'];
    name = json['name'];
    username = json['username'];
  }

  static Map<String, dynamic> toJson(
      {String name, String email, String password, String username}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['password'] = password;
    data['email'] = email;
    data['name'] = name;
    data['username'] = username;
    return data;
  }
}
