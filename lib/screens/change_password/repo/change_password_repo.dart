import 'package:jaynetwork/network/api_result.dart';
import 'package:mp3_music_converter/error_handler/handler.dart';
import 'package:mp3_music_converter/utils/instance.dart';

class ChangePasswordRepo{

  Future<ApiResponse> email(String email) async {
    final map = {'email':'$email'};
    try {
      final response =
      await jayNetworkClient.makePostRequest("sendotp", data: map);
      return ApiResponse.success(data: response);
    } catch (e) {
      return handleNetworkException(e);
    }
  }

  Future<ApiResponse> otp(Map map) async {
    try {
      final response =
      await jayNetworkClient.makePostRequest("resetpass", data: map);
      return ApiResponse.success(data: response);
    } catch (e) {
      return handleNetworkException(e);
    }
  }



}