import 'dart:convert';
import 'package:mp3_music_converter/utils/instance.dart';
import 'model.dart';
import 'package:mp3_music_converter/screens/search_follow/model/follow_model.dart';

class SearchUserProfileRepo{

Future<SearchUserProfile> searchUserProfile(String userId) async {
  final map = {'userid':'$userId'};
  try {
    var response =
    await jayNetworkClient.makePostRequest("userprofile", data: map);
    String responseString = response.toString();
    var decodedData = jsonDecode(responseString);
    dynamic mapUser = decodedData['user'];
    SearchUserProfile searchUserProfile = SearchUserProfile(
      user: User(
        name:mapUser['name'],
        profilepic: mapUser['profilepic'],
        id:mapUser['id'],
      ),
      followers: mapUser['followers'],
      following: mapUser['following'],
    );

    return searchUserProfile;
  } catch (e) {
    return throw (e);
  }
}

Future<FollowModel> follow(Map map) async {
  try {
    final response =
    await jayNetworkClient.makePostRequest("follow", data: map);
    String responseString = response.toString();
    var decodedData = jsonDecode(responseString);
    dynamic mapUser = decodedData;
    print('printing the follow issue ${mapUser['count']}');
    FollowModel followModel = FollowModel(
      played: mapUser['played'],
      count: mapUser['count'],
      message: mapUser['message']
    );
    return followModel;
  } catch (e) {
    return throw (e);
  }
}

Future<FollowModel> unFollow(Map map) async {
  try {
    final response =
    await jayNetworkClient.makePostRequest("unfollow", data: map);
    String responseString = response;
    var decodedData = jsonDecode(responseString);
    dynamic mapUser = decodedData;
    FollowModel followModel = FollowModel(
        count: mapUser['count'],
        message: mapUser['message']
    );
    return followModel;
  } catch (e) {
    return throw (e);
  }
}
}