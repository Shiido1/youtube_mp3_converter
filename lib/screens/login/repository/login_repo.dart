import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:jaynetwork/jaynetwork.dart';
import 'package:jaynetwork/network/api_result.dart';
import 'package:mp3_music_converter/error_handler/handler.dart';
import 'package:mp3_music_converter/screens/login/model/login_model.dart';
import 'package:mp3_music_converter/utils/instance.dart';

class LoginApiRepository {
  Future<ApiResponse<dynamic>> loginUser({@required Map data}) async {
    try {
      final _response =
      await jayNetworkClient.makePostRequest("login", data: data);
      final _finalData = Login_Model.fromJson(_response.data);

      _saveUsersData(_finalData);
      return ApiResponse.success(data: _finalData);
    } catch (e) {
      return handleNetworkException(e);
    }
  }

  void _saveUsersData(Login_Model finalData) async {
    /// cache users data here
  }
}
