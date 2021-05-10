import 'dart:convert';
import 'package:mp3_music_converter/utils/instance.dart';
import 'package:mp3_music_converter/screens/search_follow/model.dart';


class SearchRepository{

  Future<List<Users>> searchUser(String user) async {
    List<Users> searchUserList = [];
    final map = {'text':'$user'};
    try {
      var response =
      await jayNetworkClient.makePostRequest("search_api", data: map);
      String responseString = response.toString();
      var decodedData = jsonDecode(responseString);
      List<dynamic> mapUser = decodedData['users'];
      searchUserList.clear();
      for(int i =0; i < mapUser.length; i++){
        Users user = Users(
          name: mapUser[i]["name"],
          profilePic: mapUser[i]["profilepic"],
          id: mapUser[i]["id"],
        );
        searchUserList.add(user);
      }
      return searchUserList;
    } catch (e) {
      return throw (e);
    }
  }

}