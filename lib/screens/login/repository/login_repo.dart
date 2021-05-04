import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mp3_music_converter/screens/login/provider/login_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:jaynetwork/jaynetwork.dart';
import 'package:jaynetwork/network/api_result.dart';
import 'package:mp3_music_converter/error_handler/handler.dart';
import 'package:mp3_music_converter/screens/login/model/login_model.dart';
import 'package:mp3_music_converter/utils/helper/constant.dart';
import 'package:mp3_music_converter/utils/helper/instances.dart';
import 'package:mp3_music_converter/utils/instance.dart';

class LoginApiRepository {
  Future<ApiResponse<dynamic>> loginUser(
      {@required BuildContext context, @required Map data}) async {
    LoginProviders _provider =
        Provider.of<LoginProviders>(context, listen: false);
    try {
      final _response =
          await jayNetworkClient.makePostRequest("login", data: data);
      final _finalData = LoginModel.fromJson(_response.data);
      _saveUsersData(_finalData);

      _provider.getUserToken(_finalData.token);
      _provider.getUserEmail(_finalData.email);
      _provider.getUserName(_finalData.name);
      await _provider.saveUserToken(_finalData.token);
      await _provider.saveUserEmail(_finalData.email);
      return ApiResponse.success(data: _finalData);
    } catch (e) {
      return handleNetworkException(e);
    }
  }

  void _saveUsersData(LoginModel finalData) async {
    /// cache users data here
    preferencesHelper.saveValue(key: usersPrefkey, value: finalData.name);
    preferencesHelper.saveValue(key: usersPrefkey, value: finalData.email);
  }
}
