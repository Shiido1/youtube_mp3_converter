import 'dart:convert';
import 'package:jaynetwork/network/api_result.dart';
import 'package:mp3_music_converter/error_handler/handler.dart';
import 'package:mp3_music_converter/utils/instance.dart';
import 'package:mp3_music_converter/screens/search_follow/model.dart';


class SearchRepository{


  Future<ApiResponse> follow(Map map) async {
    try {
      final response =
      await jayNetworkClient.makePostRequest("follow", data: map);
      return ApiResponse.success(data: response);
    } catch (e) {
      return handleNetworkException(e);
    }
  }

  Future<ApiResponse> unFollow(Map map) async {
    try {
      final response =
      await jayNetworkClient.makePostRequest("unfollow", data: map);
      return ApiResponse.success(data: response);
    } catch (e) {
      return handleNetworkException(e);
    }
  }

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