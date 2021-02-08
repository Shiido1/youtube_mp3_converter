import 'package:flutter/cupertino.dart';
import 'package:jaynetwork/jaynetwork.dart';
import 'package:mp3_music_converter/screens/signup/model/signup_model.dart';
import 'package:mp3_music_converter/utils/instance.dart';

class SignUpApiRepository {
  Future<ApiResponse<SignupModel>> signUp({@required Map data}) async {
    try {
      final response =
          await jayNetworkClient.makePostRequest("register", data: data);
      return ApiResponse.success(data: SignupModel.fromJson(response.data));
    } catch (e) {
      return ApiResponse.failure(error: NetworkExceptions.handleResponse(e));
    }
  }
}
