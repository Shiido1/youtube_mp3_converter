import 'package:flutter/cupertino.dart';
import 'package:jaynetwork/network/api_result.dart';
import 'package:mp3_music_converter/error_handler/handler.dart';
import 'package:mp3_music_converter/screens/login/provider/login_provider.dart';
import 'package:mp3_music_converter/utils/instance.dart';
import 'package:provider/provider.dart';

class RedBackgroundRepo {
  BuildContext context;
  RedBackgroundRepo(this.context);

  void saveImage(String imageUrl) async {
    await Provider.of<LoginProviders>(context, listen: false)
        .getSavedUserToken();
    String token =
        Provider.of<LoginProviders>(context, listen: false).userToken;
    final map = {"token": token, "image": imageUrl};

    await image(map);
  }

  Future<ApiResponse> image(Map map) async {
    try {
      final response =
          await jayNetworkClient.makePostRequest("updatepic", data: map);
      return ApiResponse.success(data: response);
    } catch (e) {
      // image(map);
      return handleNetworkException(e);
    }
  }
}
