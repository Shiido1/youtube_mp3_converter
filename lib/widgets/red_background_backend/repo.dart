import 'package:flutter/cupertino.dart';
import 'package:jaynetwork/network/api_result.dart';
import 'package:mp3_music_converter/error_handler/handler.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/utils/instance.dart';

class RedBackgroundRepo {
  BuildContext context;
  RedBackgroundRepo(this.context);

  void saveImage(String imageUrl) async {
    String token = await preferencesHelper.getStringValues(key: 'token');
    print("token is: $token");
    final map = {"token": token, "image": imageUrl};

    await image(map);
  }

  Future<ApiResponse> image(Map map) async {
    try {
      final response =
          await jayNetworkClient.makePostRequest("updatepic", data: map);
      print(response);
      return ApiResponse.success(data: response);
    } catch (e) {
      print('this guy error occured');
      return handleNetworkException(e);
    }
  }
}
