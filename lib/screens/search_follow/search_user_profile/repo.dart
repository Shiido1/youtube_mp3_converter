import 'dart:convert';
import 'package:mp3_music_converter/utils/instance.dart';
import 'model.dart';

class SearchUserProfileRepo{

  // Future<ApiResponse> searchUserPro(String userId) async {
  //
  //   final map = {'userid':'$userId'};
  //   try {
  //     final response =
  //     await jayNetworkClient.makePostRequest("userprofile", data: map);
  //     return ApiResponse.success(data: response);
  //   } catch (e) {
  //     return handleNetworkException(e);
  //   }
  // }

Future<User> searchUserProfile(String userId) async {

  final map = {'userid':'$userId'};
  try {
    var response =
    await jayNetworkClient.makePostRequest("userprofile", data: map);
    String responseString = response.toString();
    var decodedData = jsonDecode(responseString);
    dynamic mapUser = decodedData['user'];
    User user = User(
      name:mapUser['name'],
      profilepic: mapUser['profilepic'],
      id:mapUser['id'],
    );

    return user;
  } catch (e) {
    return throw (e);
  }
}
}