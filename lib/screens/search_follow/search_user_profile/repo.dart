

import 'dart:convert';

import 'package:jaynetwork/network/api_result.dart';
import 'package:mp3_music_converter/error_handler/handler.dart';
import 'package:mp3_music_converter/utils/instance.dart';

class SearchUserProfileRepo{

  Future<ApiResponse> searchUserPro(String userId) async {

    final map = {"userid":userId};
    try {
      final response =
      await jayNetworkClient.makePostRequest("userprofile", data: map);
      return ApiResponse.success(data: response);
    } catch (e) {
      return handleNetworkException(e);
    }
  }

// Future<List<SearchUserProfile>> searchUserProfile(String user) async {
//   List<Users> searchUserList = [];
//   final map = {'text':'$user'};
//   try {
//     var response =
//     await jayNetworkClient.makePostRequest("userprofile", data: map);
//     String responseString = response.toString();
//     var decodedData = jsonDecode(responseString);
//     List<dynamic> mapUser = decodedData['users'];
//     searchUserList.clear();
//     for(int i =0; i < mapUser.length; i++){
//       Users user = Users(
//         name: mapUser[i]["name"],
//         profilePic: mapUser[i]["profilepic"],
//         id: mapUser[i]["id"],
//       );
//       searchUserList.add(user);
//     }
//     return searchUserList;
//   } catch (e) {
//     return throw (e);
//   }
// }
}