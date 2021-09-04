import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mp3_music_converter/widgets/red_background_backend/provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:jaynetwork/jaynetwork.dart';
import 'package:jaynetwork/network/api_result.dart';
import 'package:mp3_music_converter/error_handler/handler.dart';
import 'package:mp3_music_converter/screens/login/model/login_model.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/utils/instance.dart';

class LoginApiRepository {
  Future<ApiResponse<dynamic>> loginUser(
      {@required BuildContext context, @required Map data}) async {
    try {
      final _response =
          await jayNetworkClient.makePostRequest("login", data: data);
      final _finalData = LoginModel.fromJson(_response.data);
      print(_finalData.token);

      preferencesHelper.saveValue(key: 'name', value: _finalData.name);
      preferencesHelper.saveValue(key: 'email', value: _finalData.email);
      preferencesHelper.saveValue(key: 'token', value: _finalData.token);
      preferencesHelper.saveValue(key: 'id', value: _finalData.id);

      Provider.of<RedBackgroundProvider>(context, listen: false)
          .updateUrl(_finalData.profilepic);
      return ApiResponse.success(data: _finalData);
    } catch (e) {
      return handleNetworkException(e);
    }
  }
}
